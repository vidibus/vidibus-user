module Vidibus
  module User
    module Warden
      class FailureApp
        include Warden::Helper

        def self.call(env)
          self.new.call(env)
        end

        # This is a rack endpoint user authentication. It will be called
        # by the consumer after requesting an authentication code.
        def call(env)
          @env = env
          body = "Please authenticate at #{host}#{Vidibus::User.login_path}"
          header = {
            'Content-Type' => 'text/html',
            'Location' => Vidibus::User.login_path,
            'Content-Length' => body.length.to_s
          }
          [302, header, [body]]
        end

        def env
          @env
        end
      end
    end
  end
end
