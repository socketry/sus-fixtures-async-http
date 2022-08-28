# Copyright, 2022, by Samuel Williams.
# Released under the MIT License.

require 'sus/fixtures/async/http/server_context'

describe Sus::Fixtures::Async::HTTP::ServerContext do
	include Sus::Fixtures::Async::HTTP::ServerContext
	
	let(:response) {client.get("/")}
	
	it 'can perform a reqeust' do
		expect(response.read).to be == "Hello World!"
	end
	
	it 'has a timeout' do
		expect(timeout).to(be > 0).and(be < 60)
	end
	
	with '#client_endpoint' do
		it 'is suitable as an HTTP endpoint' do
			expect(client_endpoint).not.to be_nil
			expect(client_endpoint).to have_attributes(
				protocol: be == endpoint.protocol,
				scheme: be == endpoint.scheme,
				authority: be == endpoint.authority,
			)
		end
	end
end
