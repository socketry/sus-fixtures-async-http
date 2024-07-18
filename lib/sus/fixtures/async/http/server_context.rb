# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2022-2023, by Samuel Williams.

require 'sus/fixtures/async/reactor_context'

require 'async/http/server'
require 'async/http/client'
require 'async/http/endpoint'

module Sus::Fixtures
	module Async
		module HTTP
			module ServerContext
				include ReactorContext
				
				def protocol
					::Async::HTTP::Protocol::HTTP1
				end
				
				def url
					'http://localhost:0'
				end
				
				def bound_urls
					urls = []
					
					@client_endpoint.each do |address_endpoint|
						address = address_endpoint.address
						
						host = address.ip_address
						if address.ipv6?
							host = "[#{host}]"
						end
						
						port = address.ip_port
						
						urls << "#{endpoint.scheme}://#{host}:#{port}"
					end
					
					urls.sort!
					
					return urls
				end
				
				def bound_url
					bound_urls.first
				end
				
				def endpoint
					::Async::HTTP::Endpoint.parse(url, timeout: 0.8, reuse_port: true, protocol: protocol)
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
				
				def make_server_endpoint(bound_endpoint)
					bound_endpoint
				end
				
				def make_server(endpoint)
					::Async::HTTP::Server.new(middleware, endpoint)
				end
				
				def server
					@server
				end
				
				def client
					@client
				end
				
				def client_endpoint
					@client_endpoint
				end
				
				def make_client_endpoint(bound_endpoint)
					# Pass through the timeout:
					bound_endpoint.local_address_endpoint(timeout: endpoint.timeout)
				end
				
				def make_client(endpoint, **options)
					options[:retries] = retries unless options.key?(:retries)
					
					::Async::HTTP::Client.new(endpoint, **options)
				end
				
				def before
					super
					
					# We bind the endpoint before running the server so that we know incoming connections will be accepted:
					@bound_endpoint = endpoint.bound
					
					@server_endpoint = make_server_endpoint(@bound_endpoint)
					mock(@server_endpoint) do |wrapper|
						wrapper.replace(:protocol) {endpoint.protocol}
						wrapper.replace(:scheme) {endpoint.scheme}
						wrapper.replace(:authority) {endpoint.authority}
						wrapper.replace(:path) {endpoint.path}
					end
					
					@server = make_server(@server_endpoint)
					
					@server_task = Async do
						@server.run
					end
					
					@client_endpoint = make_client_endpoint(@bound_endpoint)
					mock(@client_endpoint) do |wrapper|
						wrapper.replace(:protocol) {endpoint.protocol}
						wrapper.replace(:scheme) {endpoint.scheme}
						wrapper.replace(:authority) {endpoint.authority}
						wrapper.replace(:path) {endpoint.path}
					end
					
					@client = make_client(@client_endpoint)
				end
				
				def after
					# We add a timeout here, to avoid hanging in `@client.close`:
					::Async::Task.current.with_timeout(1) do
						@client&.close
						@server_task&.stop
						@bound_endpoint&.close
					end
					
					super
				end
			end
		end
	end
end
