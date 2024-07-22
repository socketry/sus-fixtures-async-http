# Getting Started

This guide explains how to use the `sus-fixtures-async-http` gem to test HTTP clients and servers.

## Installation

Add the gem to your project:

``` bash
$ bundle add sus-fixtures-async-http
```

## Usage

Here is a simple example showing how to test the default server:

``` ruby
include Sus::Fixtures::Async::HTTP::ServerContext

let(:response) {client.get("/")}

it 'can perform a request' do
	expect(response.read).to be == "Hello World!"
end
```

### Custom Application

You can also create a custom application:

``` ruby
include Sus::Fixtures::Async::HTTP::ServerContext

let(:app) do
	Protocol::HTTP::Middleware.for do |request|
		Protocol::HTTP::Response[200, {}, ["Goodbye World!"]]
	end
end

let(:response) {client.get("/")}

it 'can perform a request' do
	expect(response.read).to be == "Goodbye World!"
end
```
