require "user/extensions/controller"

ActiveSupport.on_load(:action_controller) do
  include Vidibus::User::Extensions::Controller
end
