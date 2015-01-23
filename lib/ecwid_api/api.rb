module EcwidApi
  # Internal: A base class for common API functionality
  module Api
    require_relative "api/base"
    require_relative "api/orders"
    require_relative "api/products"
    require_relative "api/categories"
    require_relative "api/product_combinations"

    # Private: Gets the Client
    attr_reader :client
    private     :client

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
        yield(response) if block_given?
      else
        raise ResponseError.new(response)
      end
    end
  end
end