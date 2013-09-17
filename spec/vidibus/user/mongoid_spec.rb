require 'spec_helper'

describe Vidibus::User::Mongoid do
  let(:user) do
    ::User.new(:uuid => '41f61cf0a0950130b8cf38f6b1180e6b')
  end

  describe 'validation' do
    it 'should pass with valid attributes' do
      user.should be_valid
    end

    it 'should fail without an UUID' do
      user.uuid = nil
      user.should be_invalid
    end
  end
end
