require_relative "paged_enumerator"

# Public: Presents a paged Ecwid response as an Enumerator with a
# PagedEnumerator
#
# Example
#
#   response = PagedEcwidResponse.new(client, "products", priceFrom: 10) do |product_hash|
#     Product.new(product_hash, click: client)
#   end
#
#   response.each do |product|
#     # do stuff the the product
#   end
#
module EcwidApi
  class PagedEcwidResponse
    include Enumerable
    extend  Forwardable

    def_delegator :@paged_enumerator, :each

    # Public: Initialize a new PagedEcwidResponse
    #
    # client - an EcwidApi::Client
    # path   - a String that is the path to retrieve from the client
    # params - a Hash of parameters to pass along with the request
    # &block - a Block that processes each item returned in the Response
    #
    def initialize(client, path, params = {}, &block)
      params[:limit] = 100
      params.delete(:offset)

      block ||= Proc.new { |item| item }

      response = client.get(path, params)

      @paged_enumerator = PagedEnumerator.new(response) do |response, yielder|
        
        count, offset, total = %w(count offset total).map do |i|
          response.body[i].to_i
        end
        
        if count > 0
          response.body["items"].each do |item|
            yielder << block.call(item)
          end
        end  

        if count == 0 || count + offset >= total
          false
        else
          client.get(path, params.merge(offset: offset + count))
        end
      end
    end
  end
end
