module EcwidApi
  # Internal: A base class for common API functionality
  module Api
    autoload :Base,                "ecwid_api/api/base"
    autoload :Orders,              "ecwid_api/api/orders"
    autoload :Products,            "ecwid_api/api/products"
    autoload :Categories,          "ecwid_api/api/categories"
    autoload :ProductCombinations, "ecwid_api/api/product_combinations"

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