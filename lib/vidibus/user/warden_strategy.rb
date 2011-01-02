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
      connector = Service.connector
      raise "Failed to set Connector credentials! Service has not been set up, Connector data is missing." unless this and connector
      {
        :client_id => this.uuid,
        :client_secret => Vidibus::Secure.sign("#{connector.url}#{this.uuid}", this.secret),
        :connector_url => connector.url
      }
    end
  end

  # Returns this service
  def this
    @this ||= Service.this
  end

  # Returns the current realm
  def realm
    @realm ||= env[:realm] || raise("No realm available!")
  end

  # Returns OAuth client
  def client
    @client ||= OAuth2::Client.new(credentials[:client_id], credentials[:client_secret], :site => credentials[:connector_url])
  end

  def authenticate!
    code = params["code"]
    redirect_url = "#{host}/authenticate_user"

    # Fetch code first
    return redirect!(client.web_server.authorize_url(:redirect_url => redirect_url)) unless code

    # Exchange code for token and fetch user data
    access_token = client.web_server.get_access_token(code, :redirect_url => redirect_url)
    user_data = JSON.parse(access_token.get("/me"))

    unless user = User.where(:email => user_data["email"]).first
      unless user = User.create(user_data)
        raise "user.errors = #{user.errors.inspect}"
      end
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