module Vidibus
  module User
    class Error < StandardError; end
    class RealmError < Error; end
    class ServiceError < Error; end
    class SingleSignOnError < Error; end
  end
end
