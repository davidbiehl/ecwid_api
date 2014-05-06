# EcwidApi

A gem to interface with the Ecwid REST APIs.

## Installation

Add this line to your application's Gemfile:

    gem 'ecwid_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ecwid_api

## Usage

### Configure an new Client

A `Client` will interface with a single Ecwid store. The `store_id` will need
to be configured for each new `Client`.

    require 'ecwid_api'

    client = EcwidApi::Client.new do |config|
      config.store_id           = '12345'                        # your Ecwid Store ID
      config.url                = 'https://app.ecwid.com/api/v1' # default
      config.order_secret_key   = 'ORDER_SECRET_KEY'
      config.product_secret_key = 'PRODUCT_SECRET_KEY'
    end

### Make some Requests

To make a request, simply call the `#get` method on the client passing in the
API and any parameters it requires. For example, to get some categories:

    # GET https://app.ecwid.com/api/v1/[STORE-ID]/categories?parent=1

    client.get("categories", parent: 1)

    # => #<Faraday::Response>

The `Client` is responsible for making raw requests, which is why it returns
a `Faraday::Response`. Eventually there will be a domain model to bury this
detail under an abstraction. In the meantime, please see the
[Faraday documentation](https://github.com/lostisland/faraday)
to learn how to use the `Faraday::Response` object.

### Ecwid API Documentation

The [Ecwid API documentation](http://kb.ecwid.com/w/page/25232810/API)
should give you a good idea of what is possible to retreive. Please note that
resources requiring the secret keys will be inaccessible until we implement
that feature.

## Contributing

1. Fork it ( http://github.com/davidbiehl/ecwid_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The MIT License (MIT)

Copyright (c) 2014 David Biehl

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

