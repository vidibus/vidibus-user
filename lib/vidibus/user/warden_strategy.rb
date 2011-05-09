require "rubygems"
require "warden"
require "oauth2"
require "json"

Warden::Strategies.add(:connector) do
  def valid?
    true
  end

  # Sets credentials for Connector login in session.
  # The client_secret will be validated through Vidibus' OauthServer when issuing an OAuth token.
  # To protect the service's secret, a custom signature will be sent instead.
  def credentials
    @credentials ||= begin
      service = Service(:user, realm)
      raise "Failed to set service credentials! This service has not been set up, user service is missing." unless this and service
      {
        :client_id => "#{this.uuid}-#{realm}",
        :client_secret => Vidibus::Secure.sign(this.uuid, service.secret),
        :service_url => service.url
      }
    end
  end

  # Returns this service
  def this
    @this ||= Service.this
  end

  # Returns the current realm
  def realm
    @realm ||= params["realm"] || env[:realm] || raise(Vidibus::User::NoRealmError, "No realm available!")
  end

  # Returns OAuth client
  def client
    @client ||= OAuth2::Client.new(credentials[:client_id], credentials[:client_secret], :site => credentials[:service_url])
  end

  def authenticate!
    code = params["code"]
    redirect_url = "#{host}/authenticate_user?realm=#{realm}"
    args = {:redirect_url => redirect_url}

    # Fetch code first
    return redirect!(client.web_server.authorize_url(args)) unless code

    # Exchange code for token
    access_token = client.web_server.get_access_token(code, :redirect_url => redirect_url)

    # Try to fetch user data
    begin
      response = access_token.get("/oauth/user")
      user_data = JSON.parse(response)
      selector = {:uuid => user_data["uuid"]}
      user = User.where(selector).first || User.create!(selector)
      user.update_attributes!(user_data)
    rescue OAuth2::HTTPError
      Rails.logger.error "Failed to fetch user data from #{credentials[:service_url]}/oauth/user"
      user = true
    rescue => e
      Rails.logger.error "Error: #{e.message}"
    end

    success!(user)
  rescue OAuth2::HTTPError => e
    raise e.response.body
  end

  # Returns current host.
  def host
    "#{protocol}#{env["HTTP_HOST"]}"
  end

  # Returns protocol depending on SERVER_PORT.
  def protocol
    env["SERVER_PORT"] == 443 ? "https://" : "http://"
  end
end
