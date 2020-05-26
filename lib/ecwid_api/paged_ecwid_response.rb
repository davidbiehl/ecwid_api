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

    # Public: Initialize a new PagedEcwidResponse
    #
    # client - an EcwidApi::Client
    # path   - a String that is the path to retrieve from the client
    # params - a Hash of parameters to pass along with the request
    # &block - a Block that processes each item returned in the Response
    #
    def initialize(client, path, params = {}, &block)
      params[:limit] ||= 100
      params.delete(:offset)

      @client, @path, @params, @block = client, path, params, block
    end

    def each
      count = 0
      total = 0
      params = @params

      begin
        response = @client.get(@path, params)
        items = response.body["items"] || []
        items.each do |item|
          yield(@block ? @block.call(item) : item)
        end
        count, offset, total = %w(count offset total).map do |i|
          response.body[i].to_i
        end

        params = params.merge(offset: offset + count)
      end while !(count == 0 || count + offset >= total)
    end

  end
end
