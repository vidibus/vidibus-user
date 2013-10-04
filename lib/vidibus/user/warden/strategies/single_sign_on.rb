require 'oauth2'

# Warden strategy to authenticate user from a
# single sign-on cookie.
::Warden::Strategies.add(:single_sign_on) do
  include Vidibus::User::Warden::Helper

  USER_DATA_PATH = '/oauth/user'

  # Run this strategy only if a realm is present.
  def valid?
    !!realm
  end

  def user
    @user
  end

  def authenticate!
    return if fetch_code
    fetch_access_token
    fetch_user_data
    user ? success!(user) : fail!
  end

  private

  def args
    {:redirect_url => "#{host}/authenticate_user?realm=#{realm}"}
  end

  def code
    params['code']
  end

  def access_token
    @access_token ||= begin
      client.auth_code.get_token(code, args)
    end
  end

  def fetch_code
    return if code
    failsafe do
      redirect!(client.auth_code.authorize_url(args))
    end
  end

  def fetch_access_token
    failsafe do
      access_token
    end
  end

  def fetch_user_data
    begin
      response = access_token.get(USER_DATA_PATH)
      user_data = JSON.parse(response.body)
      query = {:uuid => user_data['uuid']}
      user = User.where(query).first || User.create!(query)
      user.update_attributes!(user_data)
      @user = user
    rescue OAuth2::Error => e
      logger.error("Vidibus::User: Failed to fetch user data from #{credentials[:service_url]}/#{USER_DATA_PATH}: #{e.message}")
    rescue => e
      logger.error("Vidibus::User: #{e.message}")
    end
  end

  def failsafe(&block)
    begin
      block.call
    rescue OAuth2::Error => e
      raise(Vidibus::User::SingleSignOnError, e.response.body)
    end
  end
end
