
# Public: Presents an Ecwid response as an Array
#
# Example
#
#   response = UnpagedEcwidResponse.new(client, "products", priceFrom: 10) do |product_hash|
#     Product.new(product_hash, click: client)
#   end
#
#   response.each do |product|
#     # do stuff the the product
#   end
#
module EcwidApi
  class UnpagedEcwidResponse
    include Enumerable
    extend  Forwardable

    def_delegator :@records, :each

    # Public: Initialize a new UnpagedEcwidResponse
    #
    # client - an EcwidApi::Client
    # path   - a String that is the path to retrieve from the client
    # params - a Hash of parameters to pass along with the request
    # &block - a Block that processes each item returned in the Response
    #
    def initialize(client, path, params = {}, &block)
      block ||= Proc.new { |item| item }
      @records = []

      response = client.get(path, params)
      response.body.each do |item|
        @records << block.call(item)
      end
    end
  end
end
