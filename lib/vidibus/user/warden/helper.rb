module Vidibus
  module User
    module Warden
      module Helper

        # Sets credentials for Connector login in session.
        # The client_secret will be validated through Vidibus' OauthServer
        # when issuing an OAuth token. To protect the service's secret, a
        # custom signature will be sent instead.
        def credentials
          @credentials ||= begin
            service = ::Service.discover(:user, realm)
            unless service
              raise(ServiceError, 'No user service is available.')
            end
            {
              :client_id => "#{this.uuid}-#{realm}",
              :client_secret => Vidibus::Secure.sign(this.uuid, service.secret),
              :service_url => service.url
            }
          end
        end

        # Returns this service
        def this
          @this ||= ::Service.this
        end

        # Returns the current realm
        def realm
          @realm ||= params['realm'] || env[:realm] ||
            raise(RealmError, 'No realm available!')
        end

        # Returns OAuth client
        def client
          @client ||= OAuth2::Client.new(credentials[:client_id], credentials[:client_secret], :site => credentials[:service_url])
        end

        # Returns current host.
        def host
          "#{protocol}#{env['HTTP_HOST']}"
        end

        # Returns protocol depending on SERVER_PORT.
        def protocol
          env['SERVER_PORT'] == 443 ? 'https://' : 'http://'
        end

        def logger
          Vidibus::User::Warden.logger
        end
      end
    end
  end
end
