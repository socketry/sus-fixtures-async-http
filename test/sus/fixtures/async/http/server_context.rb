# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2022-2024, by Samuel Williams.

require 'sus/fixtures/async/http/server_context'

describe Sus::Fixtures::Async::HTTP::ServerContext do
	include Sus::Fixtures::Async::HTTP::ServerContext
	
	let(:response) {client.get("/")}
	
	it 'can perform a reqeust' do
		expect(response.read).to be == "Hello World!"
	end
	
	it 'has a timeout' do
		expect(timeout).to(be > 0).and(be <= 60)
	end
	
	it 'has a bound url' do
		expect(bound_url).to be =~ %r{http://127.0.0.1}
	end
	
	it 'has a server' do
		expect(server).to be_a(::Async::HTTP::Server)
	end
	
	with '#client_endpoint' do
		it 'is suitable as an HTTP endpoint' do
			expect(client_endpoint).not.to be_nil
			expect(client_endpoint).to have_attributes(
				protocol: be == endpoint.protocol,
				scheme: be == endpoint.scheme,
				authority: be == endpoint.authority,
				path: be == endpoint.path,
			)
		end
	end
	
	# it "doesn't hang" do
	# 	response = self.response
	# 	raise "boom"
	# end
end
