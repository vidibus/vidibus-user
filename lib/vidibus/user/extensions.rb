require 'vidibus/user/extensions/controller'
require 'vidibus/user/extensions/helper'

if defined?(ActiveSupport)
  ActiveSupport.on_load(:action_controller) do
    include Vidibus::User::Extensions::Controller
  end

  ActiveSupport.on_load(:application_helper) do
    include Vidibus::User::Extensions::Helper
  end

  ActiveSupport.on_load(:action_view) do
    include Vidibus::User::Extensions::Helper
  end
end
