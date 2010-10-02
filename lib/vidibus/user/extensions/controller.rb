module Vidibus
  module User
    module Extensions

      # Contains extensions of ApplicationController.
      module Controller
        extend ActiveSupport::Concern

        included do
          helper_method :warden, :signed_in?, :user_signed_in?, :current_user, :user_session
        end

        protected

        # Accessor for the warden proxy instance.
        def warden
          request.env["warden"]
        end

        # Performs login on Connector service.
        def authenticate_user!
          return if user_signed_in?
          store_location
          warden.authenticate!(:scope => :user)
        end

        # Returns session of currently signed in user.
        def user_session
          current_user and warden.session(:user)
        end

        # Returns user currently logged in.
        def current_user
          warden.user(:user)
        end

        # Returns true if user is logged in.
        def user_signed_in?
          warden.authenticated?(:user)
        end
        alias_method :signed_in?, :user_signed_in?

        private

        # Stores current location in session to perform redirect after signin in session
        def store_location
          Rails.logger.error 'store_location: '+request.fullpath
          session[:user_return_to] = request.fullpath
        end
      end
    end
  end
end
