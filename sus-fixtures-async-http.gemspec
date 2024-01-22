# frozen_string_literal: true

require_relative "lib/sus/fixtures/async/http/version"

Gem::Specification.new do |spec|
	spec.name = "sus-fixtures-async-http"
	spec.version = Sus::Fixtures::Async::HTTP::VERSION
	
	spec.summary = "Test fixtures for running in Async::HTTP."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/socketry/sus-fixtures-async-http"
	
	spec.metadata = {
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
	}
	
	spec.files = Dir.glob(['{lib}/**/*', '*.md'], File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 2.7.0"
	
	spec.add_dependency "async-http", "~> 0.54"
	
	spec.add_dependency "sus", "~> 0.10"
	spec.add_dependency "sus-fixtures-async", "~> 0.1"
	
	spec.add_development_dependency "covered", "~> 0.20"
end
