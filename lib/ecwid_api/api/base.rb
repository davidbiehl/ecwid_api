module EcwidApi
  module Api
    # Internal: A base class for common API functionality
    class Base
      # Private: Gets the Client
      attr_reader :client
      private     :client

      # Public: Initializes a new EcwidApi::CategoryApi
      #
      # client - The EcwidApi::Client to use with the API
      #
      def initialize(client)
        @client = client
        raise Error.new("The client cannot be nil") unless client
      end

      private

      # Private: Raises an Error if a request failed, otherwise it will
      # yield the block
      #
      # response - a Faraday::Response object
      #
      # Yield if the response was successful
      #
      # Raises an error with the status code and reason if the response failed
      #
      def raise_on_failure(response)
        if response.success?
          yield if block_given?
        else
          raise ResponseError.new(response)
        end
      end
    end
  end
end