# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2022-2025, by Samuel Williams.

require "sus/fixtures/async/http"

describe Sus::Fixtures::Async::HTTP::VERSION do
	it "is a version string" do
		expect(subject).to be =~ /\d+\.\d+\.\d+/
	end
end
