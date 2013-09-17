module Vidibus
  module User
    module Extensions
      module Helper

        # Accessor for the warden proxy instance.
        def warden
          request.env['warden']
        end

        # Returns the user that is currently logged in.
        def current_user
          warden.user
        end

        # Returns the session of the currently signed-in user.
        def user_session
          warden.session if current_user
        end

        # Returns true if user is logged in.
        def authenticated?
          warden.authenticated?
        end
        alias :signed_in? :authenticated?
      end
    end
  end
end
