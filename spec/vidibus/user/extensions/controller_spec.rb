require 'spec_helper'

describe Vidibus::User::Extensions::Controller do
  let(:warden) { OpenStruct.new }
  let(:controller) do
    TestController.new.tap do |c|
      c.env = {'warden' => warden}
    end
  end

  it 'should include Helper methods' do
    controller.should respond_to(:warden)
  end

  describe '#single_sign_on' do
    context 'with current user' do
      before do
        stub(controller).authenticated? {true}
      end

      it 'should not authenticate the user with warden' do
        dont_allow(warden).authenticate.with_any_args
        controller.single_sign_on
      end
    end

    context 'without current user' do
      before do
        stub(controller).authenticated? {false}
      end

      it 'should authenticate the user with warden strategy :single_sign_on' do
        mock(warden).authenticate(:single_sign_on)
        controller.single_sign_on
      end
    end
  end

  describe '#authenticate!' do
    [:authenticate!, :signin!, :authenticate_user!].each do |method_alias|
      context 'with current user' do
        before do
          stub(controller).authenticated? {true}
        end

        it 'should not authenticate the user with warden' do
          dont_allow(warden).authenticate!.with_any_args
          controller.send(method_alias)
        end
      end

      context 'without current user' do
        before do
          stub(controller).authenticated? {false}
        end

        it 'should authenticate the user with warden' do
          mock(warden).authenticate!
          controller.send(method_alias)
        end
      end
    end
  end

  describe '#logout' do
    [:logout, :signout].each do |method_alias|
      context 'with current user' do
        before do
          stub(controller).authenticated? {true}
        end

        it 'should logout the user from warden' do
          mock(warden).logout
          controller.send(method_alias)
        end

      end

      context 'without current user' do
        before do
          stub(controller).authenticated? {false}
        end

        it 'should not logout the user from warden' do
          dont_allow(warden).logout
          controller.send(method_alias)
        end
      end
    end
  end
end
