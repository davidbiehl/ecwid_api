module Helpers
  module Client
    def client
      @client ||= EcwidApi::Client.new(12345, "access_token").tap do |client|
        allow(client).to receive(:connection).and_return(faraday)
      end
    end

    def fixtures
      %w(categories category orders products)
    end

    def faraday_stubs
      ::Faraday::Adapter::Test::Stubs.new do |stub|
        fixtures.each do |fixture|
          stub.get(fixture) { [ 200, {"Content-Type" => "application/json"}, File.read("spec/fixtures/#{fixture}.json") ] }
        end
        stub.get("/categories/5") { [200, {"Content-Type" => "application/json"}, File.read("spec/fixtures/category.json") ] }
        stub.get("/orders/35") { [200, {"Content-Type" => "application/json"}, File.read("spec/fixtures/order.json") ] }
        stub.get("/orders/404") { [404, {"Content-Type" => "application/json"}, nil ] }
      end
    end

    # Public: Returns a test Faraday::Connection
    def faraday
      ::Faraday.new do |builder|
        builder.response :json, content_type: /\bjson$/
        builder.adapter :test, faraday_stubs
      end
    end

    # Public: Returns pagination response for empty pages. To stub parameterized requests
    def empty_pagination_response
      double(body:{
        "total"=> 2,
        "count"=> 2,
        "offset"=> 0,
        "limit"=> 100,
        "items"=> []
      })
    end
  end
end