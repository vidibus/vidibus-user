require 'spec_helper'

describe 'single sign-on strategy' do
  let(:strategy) do
    Warden::Strategies[:single_sign_on].new(env)
  end
  let(:user) do
    ::User.new(:uuid => '809225c00a370131a99208606e47f892')
  end
  let(:user_data) do
    {'uuid' => user.uuid, 'email' => 'some@email.xyz'}
  end
  let(:redirect_url) do
    "#{strategy.host}/authenticate_user?realm=#{strategy.realm}"
  end
  let(:oauth_error) { OAuth2::Error.new(OpenStruct.new(body: 'error')) }

  before do
    stub(strategy).realm { realm }
    stub(strategy).host { 'http://client.local'}
    connector && this_service
    stub(::Service).discover(:user, realm) { user_service }
  end

  it 'should be available as :single_sign_on' do
    Warden::Strategies[:single_sign_on].should_not be_nil
  end

  it 'should be runnable without errors' do
    expect { strategy._run! }.to_not raise_error
  end

  context 'without a code' do
    it 'should fetch a code' do
      mock(strategy).fetch_code { true }
      strategy._run!
    end

    it 'should redirect the user' do
      mock(strategy).redirect!.with_any_args { true }
      strategy._run!
    end

    it 'should use the URL of the OAuth2 client' do
      mock(strategy.client.auth_code)
        .authorize_url(redirect_url: redirect_url) { true }
      strategy._run!
    end

    context 'and a defect oauth provider' do
      before do
        stub(strategy.client.auth_code)
          .authorize_url(redirect_url: redirect_url) { raise(oauth_error) }
      end

      it 'should should raise a single sign on error' do
        expect { strategy._run! }.
          to raise_error(Vidibus::User::SingleSignOnError)
      end
    end
  end

  context 'with a code' do
    let(:code) { 'abc' }

    before do
      stub(strategy).code { code }
    end

    it 'should not redirect the user' do
      dont_allow(strategy).redirect!.with_any_args
      stub(strategy).fetch_access_token
      stub(strategy).fetch_user_data
      strategy._run!
    end

    it 'should request an access token' do
      stub_request(:post, 'http://user.local/oauth/token').
        with({
          body: {
            'client_id' => '344b4b8088fb012dd3e558b035f038ab-7d4ef7d0974a012d10ad58b035f038ab',
            'client_secret' => 'd1a3ae98b5ee37493988381bfc47f7806105b150c5107bef70832e780b20e9ec',
            'code' => 'abc',
            'grant_type' => 'authorization_code',
            'redirect_url' => redirect_url
          }
        }).
        to_return({
          :status => 200,
          :body => {'access_token' => '<token>'}.to_json,
          :headers => {'Content-Type' => 'application/json'}
        })
      stub(strategy).fetch_user_data
      strategy._run!
    end

    context 'and an access token' do
      let(:access_token) { OpenStruct.new }

      before do
        stub(strategy).access_token { access_token }
      end

      it 'should fetch user data' do
        mock(access_token).get(USER_DATA_PATH) do
          OpenStruct.new(body: user_data.to_json)
        end
        strategy._run!
      end

      context 'with a defect user data provider' do
        before do
          stub(access_token).get(USER_DATA_PATH) { raise(oauth_error) }
        end

        it 'should log errors' do
          mock(strategy.logger).error.with_any_args
          strategy._run!
        end

        it 'should catch any OAuth2::Error' do
          stub(strategy.logger).error.with_any_args
          expect { strategy._run! }.not_to raise_error
        end

        it 'should call fail!' do
          stub(strategy.logger).error.with_any_args
          mock(strategy).fail!
          strategy._run!
        end
      end

      context 'with a working user data provider' do
        before do
          stub(access_token).get(USER_DATA_PATH) do
            OpenStruct.new(body: user_data.to_json)
          end
        end

        it 'should not log any errors' do
          dont_allow(strategy.logger).error.with_any_args
          strategy._run!
        end

        it 'should try to find a matching user' do
          mock(User).where(uuid: user.uuid) { [] }
          strategy._run!
        end

        it 'should create a new user' do
          mock(User).create!(uuid: user.uuid) { user }
          strategy._run!
        end

        context 'and an existing user' do
          before do
            stub(User).where(uuid: user.uuid) { [user] }
          end

          it 'should not create a new user' do
            dont_allow(User).create!
            strategy._run!
          end

          it 'should update attributes on user' do
            mock(user).update_attributes!(user_data)
            strategy._run!
          end
        end

        it 'should call success! with user' do
          user.update_attributes(user_data)
          mock(strategy).success!(user)
          strategy._run!
        end

        it 'should not call fail!' do
          dont_allow(strategy).fail!
          strategy._run!
        end
      end

      context 'and an erroneous model implementation' do
        before do
          stub(user).update_attributes! { raise }
        end

        it 'should log errors' do
          mock(strategy.logger).error.with_any_args
          strategy._run!
        end

        it 'should catch any StandardError' do
          stub(strategy.logger).error.with_any_args
          expect { strategy._run! }.not_to raise_error
        end

        it 'should call fail!' do
          stub(strategy.logger).error.with_any_args
          mock(strategy).fail!
          strategy._run!
        end
      end
    end
  end

  describe '#valid?' do
    it 'should return true if a realm is given' do
      stub(strategy).realm { '123' }
      strategy.valid?.should be_true
    end

    it 'should return false if no realm is given' do
      stub(strategy).realm { nil }
      strategy.valid?.should be_false
    end
  end

  describe '#user' do
    it 'should be an accessor for @user' do
      strategy.instance_variable_set('@user', user)
      strategy.user.should eq(user)
    end
  end
end
