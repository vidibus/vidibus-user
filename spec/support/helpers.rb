# Simple Rack app for session handling.
class SessionApp
  attr_accessor :app
  def initialize(app,configs = {})
    @app = app
  end

  def call(env)
    env['rack.session'] ||= {}
    @app.call(env)
  end
end

# Mocks Rack environment with optional params.
def env_with_params(path = '/', params = {}, env = {})
  method = params.delete(:method) || 'GET'
  env = {'HTTP_VERSION' => '1.1', 'REQUEST_METHOD' => "#{method}"}.merge(env)
  Rack::MockRequest.env_for("#{path}?#{Rack::Utils.build_query(params)}", env)
end

# Returns default Rack environment.
def env
  @env ||= env_with_params
end

# Sets up a mini Rack environment
def setup_rack(app = nil)
  app ||= block if block_given?
  Rack::Builder.new do
    use SessionApp
    use Warden::Manager
    run app
  end
end

# Runs the given Rack app with given environment.
def run_app(app, env)
  setup_rack(app).call(env)
end

# Returns a valid Rack response.
def valid_response
  Rack::Response.new('OK').finish
end
