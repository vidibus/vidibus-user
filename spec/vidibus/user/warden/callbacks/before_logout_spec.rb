require 'spec_helper'

describe 'warden callback :before_logout' do
  let(:user) { OpenStruct.new(:id => 'foo') }
  let(:app) do
    lambda do |env|
      env['warden'].set_user(user)
      env['warden'].logout
      valid_response
    end
  end

  it 'should do nothing unless the request cookie is around' do
    status, headers, body = run_app(app, env)
    headers.should_not have_key('Set-Cookie')
  end

  it 'should send a request to the central user registration'
end
