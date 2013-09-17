class TestHelper
  include Vidibus::User::Extensions::Helper

  attr_accessor :env

  def request
    self
  end
end
