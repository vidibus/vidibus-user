require 'spec_helper'

describe 'warden callback :after_set_user' do
  let(:user) { OpenStruct.new(:id => 'foo') }
  let(:app) do
    lambda do |env|
      env['warden'].set_user(user)
      valid_response
    end
  end

  it 'should validate the SSO session' do
    pending
    run_app(app, env)
  end
end
