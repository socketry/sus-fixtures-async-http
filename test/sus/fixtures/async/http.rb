# Copyright, 2022, by Samuel Williams.
# Released under the MIT License.

require 'sus/fixtures/async/http'

describe Sus::Fixtures::Async::HTTP::VERSION do
	it 'is a version string' do
		expect(subject).to be =~ /\d+\.\d+\.\d+/
	end
end
