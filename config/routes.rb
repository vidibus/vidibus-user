require "user/callback_app"

Rails.application.routes.draw do
  match "/authenticate_user" => Vidibus::User::CallbackApp
end
