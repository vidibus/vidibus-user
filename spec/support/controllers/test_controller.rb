class TestController
  include Vidibus::User::Extensions::Controller

  attr_accessor :env

  def request
    self
  end
end
