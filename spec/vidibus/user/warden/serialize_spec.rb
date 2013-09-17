require 'spec_helper'

describe 'Warden::Manager user serialization' do
  let(:user) do
    ::User.new(:uuid => '809225c00a370131a99208606e47f892')
  end
  let(:serializer) { Warden::SessionSerializer.new(env) }

  describe '.serialize_into_session' do
    it 'should call id on given object' do
      mock(user).id
      serializer.serialize(user)
    end
  end

  describe '.serialize_from_session' do
    it 'should call id on given object' do
      mock(User).find(user.id)
      serializer.deserialize(user.id)
    end
  end
end
