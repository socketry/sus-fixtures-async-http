# Copyright, 2022, by Samuel Williams.
# Released under the MIT License.

require 'sus/fixtures/async/reactor_context'

require 'async/http/server'
require 'async/http/client'
require 'async/http/endpoint'
require 'async/io/shared_endpoint'

module Sus::Fixtures
	module Async
		module HTTP
			module ServerContext
				include ReactorContext
				
				def timeout = nil
				
				def protocol
					::Async::HTTP::Protocol::HTTP1
				end
				
				def endpoint
					::Async::HTTP::Endpoint.parse('http://localhost:0', timeout: 0.8, reuse_port: true, protocol: protocol)
				end
				
				def retries
					1
				end
				
				def app
					::Protocol::HTTP::Middleware::HelloWorld
				end
				
				def middleware
					app
				end
				
				def server
					::Async::HTTP::Server.new(middleware, @bound_endpoint)
				end
				
				def client
					@client
				end
				
				def before
					# We bind the endpoint before running the server so that we know incoming connections will be accepted:
					@bound_endpoint = ::Async::IO::SharedEndpoint.bound(endpoint)
					@address_endpoint = @bound_endpoint.local_address_endpoint
					
					# I feel a dedicated class might be better than this hack:
					mock(@bound_endpoint) do |mock|
						mock.replace(:protocol) {endpoint.protocol}
						mock.replace(:scheme) {endpoint.scheme}
					end
					
					mock(@address_endpoint) do |mock|
						mock.replace(:protocol) {endpoint.protocol}
						mock.replace(:scheme) {endpoint.scheme}
						mock.replace(:authority) {endpoint.authority}
					end
					
					@server_task = Async do
						server.run
					end
					
					@client = ::Async::HTTP::Client.new(@address_endpoint, protocol: endpoint.protocol, retries: retries)
				end
				
				def after
					@client&.close
					@server_task&.stop
					@bound_endpoint&.close
				end
			end
		end
	end
end
