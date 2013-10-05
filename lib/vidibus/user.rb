require 'vidibus/user/errors'
require 'vidibus/user/mongoid'
require 'vidibus/user/warden'
require 'vidibus/user/extensions'
require 'vidibus/user/railstie'

module Vidibus
  module User
    extend self

    attr_accessor :login_path
    @login_path = '/login'

    attr_accessor :failure_app
    @failure_app = Vidibus::User::Warden::FailureApp
  end
end
