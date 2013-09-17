require 'spec_helper'

describe Vidibus::User::Warden::Helper do
  let(:helper) { Warden::Strategies[:single_sign_on].new(env) }

  def stub_user_service
    stub(helper).realm { realm }
    connector && this_service
    stub(::Service).discover(:user, realm) { user_service }
  end

  describe '#this' do
    it 'should call Service.this' do
      mock(::Service).this
      helper.this
    end
  end

  describe '#realm' do
    it 'should return "realm" from params' do
      realm = Object.new
      helper.params['realm'] = realm
      helper.realm.should eq(realm)
    end

    it 'should return :realm from env' do
      realm = Object.new
      helper.env[:realm] = realm
      helper.realm.should eq(realm)
    end

    it 'should raise an error if realm is unset' do
      expect { helper.realm }.
        to raise_error(Vidibus::User::RealmError)
    end
  end

  describe '#host' do
    it 'should call #protocol' do
      mock(helper).protocol
      helper.host
    end

    it 'should return a string containing http host' do
      stub(helper).protocol { 'whatever://' }
      helper.env['HTTP_HOST'] = 'it.be'
      helper.host.should eq('whatever://it.be')
    end
  end

  describe '#protocol' do
    it 'should return "http://" by default' do
      helper.protocol.should eq('http://')
    end

    it 'should return "http://" for server port 80' do
      helper.env['SERVER_PORT'] = 80
      helper.protocol.should eq('http://')
    end

    it 'should return "https://" for server port 443' do
      helper.env['SERVER_PORT'] = 443
      helper.protocol.should eq('https://')
    end
  end

  describe '#credentials' do
    it 'should discover and require a user service for current realm' do
      stub(helper).realm { realm }
      mock(::Service).discover(:user, realm)
      expect { helper.credentials }.
        to raise_error(Vidibus::User::ServiceError)
    end

    it 'should return credentials for discovered user service' do
      stub_user_service
      helper.credentials.should eq({
        :client_id => '344b4b8088fb012dd3e558b035f038ab-7d4ef7d0974a012d10ad58b035f038ab',
        :client_secret => 'd1a3ae98b5ee37493988381bfc47f7806105b150c5107bef70832e780b20e9ec',
        :service_url => 'http://user.local'
      })
    end
  end

  describe '#client' do
    let(:credentials) do
      {
        :client_id => 'a-b',
        :client_secret => 'c',
        :service_url => 'http://user.local'
      }
    end

    before do
      stub_user_service
    end

    it 'should return an OAuth2::Client' do
      helper.client.should be_a(OAuth2::Client)
    end

    it 'should initialize the client with credentials' do
      stub(helper).credentials { credentials }
      mock(OAuth2::Client).new(credentials[:client_id], credentials[:client_secret], :site => credentials[:service_url])
      helper.client
    end
  end

  describe '#logger' do
    it 'should return Vidibus::User::Warden.logger' do
      mock(Vidibus::User::Warden).logger
      helper.logger
    end
  end
end
