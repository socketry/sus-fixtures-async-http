# Sus::Fixtures::Async::HTTP

Provides a convenient fixture for running a web server.

## Installation

```bash
$ bundle add sus-fixtures-async-http
```

## Usage

```ruby
include Sus::Fixtures::Async::HTTP::ServerContext

let(:response) {client.get("/")}

it 'can perform a reqeust' do
	expect(response.read).to be == "Hello World!"
end
```