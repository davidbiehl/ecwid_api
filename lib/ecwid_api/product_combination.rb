module EcwidApi
  class ProductCombination < Entity
    include Api
    attr_reader :product

    def initialize(data, opts={})
      super(data, opts)
      @product = opts[:product]
    end

    # Public: Uploads a primary image for a ProductCombination
    #
    # filename - a String that is either a local file name or URL
    #
    # Raises ResponseError if the API returns an error
    #
    # Returns a Faraday::Response object
    def upload_image!(filename)
      client.post("products/#{product.id}/combinations/#{id}/image") do |req|
        req.body = open(filename).read
      end.tap do |response|
        raise_on_failure(response)
      end
    end
  end
end