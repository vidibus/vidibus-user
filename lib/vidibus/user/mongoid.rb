module Vidibus
  module User
    module Mongoid
      extend ActiveSupport::Concern
      included do
        field :uuid
        field :email
        validates :uuid, :uuid => true
      end
    end
  end
end
