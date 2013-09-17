require 'vidibus/user/warden/serialize'
require 'vidibus/user/warden/helper'
require 'vidibus/user/warden/strategies'
require 'vidibus/user/warden/callbacks'

module Vidibus
  module User
    module Warden
      extend self

      attr_accessor :logger
      @logger = Logger.new(STDOUT)
    end
  end
end
