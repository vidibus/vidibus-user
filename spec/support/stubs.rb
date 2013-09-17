# Helper for stubbing time. Define String to be set as Time.now.
#
# Basic usage:
#   stub_time('01.01.2010 14:00')
#   stub_time(2.days.ago)
#
# You may also provide a block that will be executed within the given time:
#   stub_time(2.days.ago) do
#     puts Time.now
#   end
#
def stub_time(string = nil, &block)
  @now ||= Time.now
  string ||= Time.now.to_s
  now = Time.parse(string.to_s)
  stub(Time).now {now}
  if block_given?
    yield
    stub(Time).now {@now}
  end
  now
end

def realm
  @realm ||= '7d4ef7d0974a012d10ad58b035f038ab'
end

def connector
  @connector ||= ::Service.create!({
    :function => 'connector',
    :url => 'http://connector.local',
    :uuid => '60dfef509a8e012d599558b035f038ab',
    :secret => nil,
    :realm_uuid => nil
  })
end

def this_service
  @this_service ||= ::Service.create!({
    :function => 'manager',
    :url => 'http://manager.local',
    :uuid => '344b4b8088fb012dd3e558b035f038ab',
    :secret => 'EaDai5nz16DbQTWQuuFdd4WcAiZYRPDwZTn2IQeXbPE4yBg3rr',
    :realm_uuid => nil,
    :this => true
  })
end

def user_service
  @user_service ||= ::Service.create!({
    :function => 'user',
    :url => 'http://user.local',
    :uuid => 'c0861d609247012d0a8b58b035f038ab',
    :secret => 'A7q8Vzxgrk9xrw2FCnvV4bv01UP/LBUUM0lIGDmMcB2GsBTIqx',
    :realm_uuid => realm
  })
end

# Stub service discovery.
def stub_service
  stub(::Service).discover { true }
  stub(::Service.discover).post
  stub(::Service.discover).put
end

# # Stubs a single sign-on warden cookie on all Warden::Proxy instances.
# # Cookies set as Warden::Proxy#warden_cookies will be returned to the client.
# def stub_sso_warden_cookie(value)
#   stub.any_instance_of(Warden::Proxy).warden_cookies.any_number_of_times do
#     {sso_cookie_key => {:value => value}}
#   end
# end

# # Stubs a single sign-on request cookie on all Warden::Proxy instances.
# # Request cookies are received from the client.
# def stub_sso_request_cookie(value)
#   stub.proxy.any_instance_of(Warden::Proxy).request do |request|
#     stub(request).cookies {{sso_cookie_key => value}}
#   end
# end

# # Stubs a single sign-on session value.
# def stub_sso_session(value)
#   env['rack.session'] ||= {}
#   env['rack.session'][sso_cookie_key] = value
# end

# # Return default GET headers.
# def stub_get_headers
#   {'Accept' => 'application/json', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Vidibus API client'}
# end

# # Return default POST headers.
# def stub_post_headers
#   {'Accept' => 'application/json', 'Content-Type' => 'application/json', 'User-Agent' => 'Vidibus API client'}
# end
