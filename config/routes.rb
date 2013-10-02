require 'vidibus/user/callback_app'

Rails.application.routes.draw do
  get '/authenticate_user' => Vidibus::User::CallbackApp
end
