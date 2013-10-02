if defined?(::Rails::Engine)
  module Vidibus
    module User
      class Engine < ::Rails::Engine

        # Add warden to rack stack and use vidibus strategy.
        config.app_middleware.use ::Warden::Manager do |manager|
          manager.default_strategies :single_sign_on
          manager.default_scope = :user
        end

        config.after_initialize do
          Vidibus::User::Warden.logger = Rails.logger
        end
      end
    end
  end
end
