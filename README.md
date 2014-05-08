# EcwidApi

A gem to interface with the Ecwid REST APIs.

[![Code Climate](https://codeclimate.com/github/davidbiehl/ecwid_api.png)](https://codeclimate.com/github/davidbiehl/ecwid_api)

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

## APIs

### Category API

The Category API will allow you to access the categories for an Ecwid store.
An instance of the Category API is available on the client.

    api = client.categories
    # => #<EcwidApi::CategoryApi>

    api.all
    # Returns an Array of all of the `EcwidApi::Category` objects

    api.root
    # Returns an Array of the top-level `EcwidApi::Category` objects for the
    # store

    api.find(123)
    # Returns the `EcwidApi::Category` with an ID of 123

#### EcwidApi::Category Objects

The properties of an `EcwidApi::Category` object can be accessed using the `[]`
method, or with special snake_cased helper methods.

    cat = client.categories.find(123)
    # An example response from the API
    # {
    #   "id": 123,
    #   "parentId": 456,
    #   "name": "Special Category"
    # }

    cat[:id]          # Access with a Symbol
    # => 123

    cat["parentId"]   # Access with a String (case sensitive)
    # => 456

    cat.parent_id     # Access with a snake_case method
    # => 456

Each `EcwidApi::Category` also has methods to find any sub-categories, and the
parent category, if there is one.

    cat.parent
    # Returns the parent `EcwidApi::Category`

    cat.sub_categories
    # Returns an Array of `EcwidApi::Category`

### Making Ad-Hoc Requests with the Client

To make a request, simply call the `#get` method on the client passing in the
relative path and any parameters it requires.
For example, to get some categories:

    # GET https://app.ecwid.com/api/v1/[STORE-ID]/categories?parent=1

    client.get("categories", parent: 1)

    # => #<Faraday::Response>

The `Client` is responsible for making raw requests, which is why it returns
a `Faraday::Response`. The JSON parsing middleware is also active on the Faraday
connection, so calling `Faraday::Response#body` will return a Hash of the parsed
JSON.

### Ecwid API Documentation

The [Ecwid API documentation](http://kb.ecwid.com/w/page/25232810/API)
should give you a good idea of what is possible to retreive. It also defines
which properties are available on each of the entities it provies. Please note
that resources requiring the secret keys will be inaccessible until we implement
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

