require 'spec_helper'

describe Vidibus::User::Extensions::Helper do
  let(:warden) { OpenStruct.new }
  let(:helper) do
    TestHelper.new.tap do |c|
      c.env = {'warden' => warden}
    end
  end

  describe '#warden' do
    it 'should provide access to the warden instance' do
      helper.warden.should eq(helper.env['warden'])
    end
  end

  describe '#current_user' do
    it 'should return the current user from warden' do
      mock(warden).user
      helper.current_user
    end
  end

  describe '#user_session' do
    context 'with current user' do
      before do
        stub(helper).current_user {true}
      end

      it 'should return the current user session from warden' do
        mock(warden).session {{'what' => 'ever'}}
        helper.user_session.should eql({'what' => 'ever'})
      end
    end

    context 'without current user' do
      before do
        stub(helper).current_user {nil}
      end

      it 'should not return the current user session from warden' do
        dont_allow(warden).session
        helper.user_session
      end
    end
  end

  describe '#authenticated?' do
    before do
      stub(helper).session { {} }
    end

    [:authenticated?, :signed_in?].each do |method_alias|
      it 'should check if the user is authenticated on warden' do
        mock(warden).authenticated?#.times(2)
        helper.send(method_alias)
      end
    end
  end
end
