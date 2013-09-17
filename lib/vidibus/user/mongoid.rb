require 'vidibus-uuid'

module Vidibus
  module User
    module Mongoid
      extend ActiveSupport::Concern
      included do
        field :uuid, type: String
        field :email, type: String
        validates :uuid, :uuid => true
      end
    end
  end
end
