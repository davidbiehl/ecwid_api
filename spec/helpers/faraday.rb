require 'faraday'

module Helpers
  module Faraday
    def fixtures
      %w(categories category orders)
    end

    def faraday_stubs
      ::Faraday::Adapter::Test::Stubs.new do |stub|
        fixtures.each do |fixture|
          stub.get(fixture) { [ 200, {"Content-Type" => "application/json"}, File.read("spec/fixtures/#{fixture}.json") ] }
        end
      end
    end

    # Public: Returns a test Faraday::Connection
    def faraday
      ::Faraday.new do |builder|
        builder.response :json, content_type: /\bjson$/
        builder.adapter :test, faraday_stubs
      end
    end

    # Public: Uses the Faraday stub connection with the client
    def faraday_client(client)
      allow(client).to receive(:connection).and_return(faraday)
    end
  end
end