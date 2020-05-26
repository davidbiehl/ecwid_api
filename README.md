# EcwidApi

A gem to interface with the Ecwid REST APIs.

[![Maintainability](https://api.codeclimate.com/v1/badges/2de4c62b3dc5f35217a5/maintainability)](https://codeclimate.com/github/platehub/ecwid_api/maintainability)
[![Build Status](https://travis-ci.org/platehub/ecwid_api.svg?branch=master)](https://travis-ci.org/platehub/ecwid_api)

## API v3 Warning!

This is for the latest version of the API, also known as v3, which is currently
in closed beta! The (incomplete) v1 API is still available on the
[api-v1 branch](https://github.com/davidbiehl/ecwid_api/tree/api-v1).

To participate in the beta, please contact Ecwid and they will give you the
information necessary to configure and authorize your application with OAuth2.

[Ecwid's API Documentation](http://api.ecwid.com) will be an important reference
in order to understand what their API is capable of.

## Installation

Add this line to your application's Gemfile:

    gem 'ecwid_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ecwid_api

## Usage

### Get Authorized with OAuth2

Ecwid API v3 uses OAuth2 to authorize 3rd party apps to use the API with a
store. The `EcwidApi::OAuth` class helps facilitate this process. Once you
get setup with a `client_id` and `client_secret` from Ecwid, configure a new
instance like so:

    @auth = EcwidApi::OAuth.new do |config|
      config.client_id = "the client id"
      config.client_secret = "the client secret (shh...)"
      config.redirect_uri   = "https://example.com/oauth"
      config.scope         = "the_permissions_i_want"
    end

The `#oauth_url` method will provide the URL that the user needs to go to
to authorize your application with their store. It can be used in Rails like so:

    link_to @auth.oauth_url, "Click here to Authorize this Groovy App!"

When the user authorizes your app, they will be redirected to the `redirect_uri`
with a `code` parameter in the query string.
Just send that code to the `#access_token` method to complete the authorization
and get your `access_token` and `store_id`.

    # https://example.com/oauth?code=super_secret_temporary_code

    token = @auth.access_token(params[:code])

    token.access_token  # the token for the Client
    token.store_id      # the store_id for the Client

### Configure an new Client

A `Client` will interface with a single Ecwid store. The `store_id` and OAuth
`access_token` will need to be provided to the client.

    require 'ecwid_api'

    client = EcwidApi::Client.new(store_id, access_token)

## The APIs

### Entities

Instead of returning raw JSON from the API, there are Entities that will help
you work with the data. The [Ecwid API](http://api.ecwid.com)
will give you all of the fields that are available for every entity. Our
Entities will give you access to the data with the `[]` method, or a snake_case
version of the property name. For example, with an `EcwidApi::Category` the
following would be possible:

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

### Category API

The Category API will allow you to access the categories for an Ecwid store.
An instance of the Category API is available on the client.

    api = client.categories
    # => #<EcwidApi::Api::Categories>

    api.all
    # Returns an Array of all of the `EcwidApi::Category` objects

    api.root
    # Returns an Array of the top-level `EcwidApi::Category` objects for the
    # store

    api.find(123)
    # Returns the `EcwidApi::Category` with an ID of 123

#### EcwidApi::Category Entities

Each `EcwidApi::Category` has methods to find sub-categories and the
parent category, if there is one.

    cat.parent
    # Returns the parent `EcwidApi::Category`

    cat.sub_categories
    # Returns an Array of `EcwidApi::Category`

### Order API

The Order API will allow you to access the orders that have been placed in an
Ecwid store. An instance of the Order API is available to the client

    api = client.orders

    api.all
    # Returns a `PagedEnumerator` containing all of the orders for the store

    api.all({createdFrom: "1982-05-17"})
    # Paremters can be passed as a Hash.
    # See http://api.ecwid.com/#search-orders
    # a list of available parameters

    api.find(123)
    # Returns an `EcwidApi::Order` object for order 123

#### EcwidApi::Order Entities

There are a few helper methods on the `EcwidApi::Order` that assist in accessing
related Entities.

    order.billing_person
    # Returns a EcwidApi::Person

    order.shipping_person
    # Returns an EcwidApi::Person

    order.items
    # Returns an Array of EcwidApi::OrderItem objects

The fulfillment status and shipping tracking code can also be updated for an
`EcwidApi::Order` object.

    order.fulfillment_status = :processing
    order.shipping_tracking_code = "1Z1234567890"
    order.save

### Making Ad-Hoc Requests with the Client

To make a request, simply call the `#get` method on the client passing in the
relative path and any parameters it requires.
For example, to get some categories:

    # GET https://app.ecwid.com/api/v3/[STORE-ID]/categories?parent=1

    client.get("categories", parent: 1)

    # => #<Faraday::Response>

The `Client` is responsible for making raw requests, which is why it returns
a `Faraday::Response`. The JSON parsing middleware is also active on the Faraday
connection, so calling `Faraday::Response#body` will return a Hash of the parsed
JSON.

### Ecwid API Documentation

The [Ecwid API documentation](http://api.ecwid.com)
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

