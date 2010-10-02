require "rails"

$:.unshift(File.join(File.dirname(__FILE__), "vidibus"))
require "user"

module Vidibus
  module User
    class Engine < ::Rails::Engine
      
      # Add warden to rack stack and use connector strategy.
      config.app_middleware.use Warden::Manager do |manager|
        manager.default_strategies :connector
        manager.default_scope = :user
      end
    end
  end
end
