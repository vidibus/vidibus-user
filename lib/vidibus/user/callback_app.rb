module Vidibus
  module User
    class CallbackApp
      def self.call(env)
        self.new.call(env)
      end

      # This is just a rack endpoint for Connector authentication. It will be called
      # by the Connector after requesting an authentication code.
      def call(env)
        env["warden"].authenticate!(:scope => :user)

        # Redirect to return path after signin
        return_to = env["rack.session"][:user_return_to] || "/"
        [302, {"Content-Type" => "text/html", "Location" => return_to}, ["Login successful."]]
      end
    end
  end
end
