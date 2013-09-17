require 'vidibus/user/extensions/helper'

module Vidibus
  module User
    module Extensions
      module Controller
        include Helper

        # Authenticates user from single sign on cookie.
        # Nothing happens if authentication fails.
        def single_sign_on
          return if authenticated?
          warden.authenticate(:single_sign_on)
        end

        # Authenticates user either from single sign on cookie
        # or from email and password params.
        # Throws a Vidibus::User::UnauthenticatedError
        # if authentication fails.
        def authenticate!
          return if authenticated?
          warden.authenticate!
        end
        alias :signin! :authenticate!
        alias :authenticate_user! :authenticate!

        # Performs logout.
        def logout
          return unless authenticated?
          warden.logout
        end
        alias :signout :logout
      end
    end
  end
end
