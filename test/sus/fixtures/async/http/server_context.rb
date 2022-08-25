# Copyright, 2022, by Samuel Williams.
# Released under the MIT License.

require 'sus/fixtures/async/http/server_context'

describe Sus::Fixtures::Async::HTTP::ServerContext do
	include Sus::Fixtures::Async::HTTP::ServerContext
	
	let(:response) {client.get("/")}
	
	it 'can perform a reqeust' do
		expect(response.read).to be == "Hello World!"
	end
end
