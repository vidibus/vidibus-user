module Vidibus
  module User
    module Mongoid
      extend ActiveSupport::Concern
      included do
        field :uuid
        validates :uuid, :uuid => true
      end
    end
  end
end
