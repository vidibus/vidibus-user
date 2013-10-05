require 'spec_helper'

describe Vidibus::User do
  let(:subject) { Vidibus::User }

  describe '.login_path' do
    it 'should point to /login by default' do
      subject.login_path.should eq('/login')
    end

    it 'should be overridable' do
      subject.login_path = '/whatever'
      subject.login_path.should eq('/whatever')
    end
  end
end
