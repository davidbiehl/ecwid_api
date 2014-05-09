module EcwidApi
  # Public: Abstracts pagination into an Enumerator so all of the objects for
  # a given response can be retreived without having to know that they were
  # split into pages from the server
  #
  # Examples
  #
  #   client.get("orders", limit: 10)
  #
  #   paged = PagedEnumerator.new(orders) do |response, yielder|
  #     response.body["orders"].each do |obj|
  #       yielder << obj
  #     end
  #
  #     next_url = response.body["nextUrl"]
  #     next_url ? client.get(next_url) : false
  #   end
  #
  #   paged.each do |item|
  #     puts item.inspect
  #   end
  #
  class PagedEnumerator
    include Enumerable

    # Private: A response that we are evaluating
    attr_reader :response
    private     :response

    # Private: Gets the next response
    attr_reader :next_block
    private     :next_block

    # Public: Initializes a new PagedEnumerator
    #
    # response   - the response that contains a collection of objects
    # next_block - The block will receive the response and a yielder Proc.
    #              The block should use `yielder << item` to yield all of
    #              the items in the collection.
    #
    #              Then the block should return the next response. If no
    #              response is given (eg: the last page), the block should
    #              return a falsey value.
    #
    def initialize(response, &next_block)
      @response, @next_block = response, next_block
    end

    # Public: Iterates over each "page" yielding each "item" in every collection
    def each(&block)
      unless @next_enumerator
        @yielder ||= []
        @next_response ||= next_block.call(response, @yielder)

        if @next_response
          @next_enumerator ||= PagedEnumerator.new(@next_response, &@next_block)
        else
          @next_enumerator = []
        end
      end

      @yielder.each(&block)
      @next_enumerator.each(&block)
    end
  end
end
