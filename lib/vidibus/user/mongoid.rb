module Vidibus
  module User
    module Mongoid
      extend ActiveSupport::Concern
      included do
        field :uuid
        field :email
        field :name
        validates :email, :name, :presence => true
        validates :uuid, :uuid => true
      end
    end
  end
end
