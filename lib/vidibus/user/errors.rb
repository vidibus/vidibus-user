module Vidibus
  module User
    class Error < StandardError; end
    class ServiceError < Error; end
    class SingleSignOnError < Error; end
  end
end
