require_relative "../paged_ecwid_response"

module EcwidApi
  module Api
    # Public: This is the Ecwid API for Orders. It abstracts the end-points
    # of the Ecwid API that deal with orders.
    class Orders < Base
      # Public: Gets Orders from the Ecwid API
      #
      # params - optional parameters that can be used to filter the request.
      #          For a list of params, please refer to the API documentation:
      #          http://kb.ecwid.com/w/page/43697230/Order%20API
      #          Note that the limit and offset parameters will be overridden
      #          since all orders will be returned and enumerated
      #
      # Returns a PagedEnumerator of `EcwidApi::Order` objects
      def all(params = {})
        PagedEcwidResponse.new(client, "orders", params) do |order_hash|
          Order.new(order_hash, client: client)
        end
      end

      # Public: Finds a an Order given an Ecwid order_number
      #
      # order_number - an Integer that is the Ecwid Order number
      #
      # Returns an EcwidApi::Order if found, nil if not
      def find(order_number)
        response = client.get("orders/#{order_number}")
        if response.success?
          Order.new(response.body, client: client)
        end
      end
    end
  end
end
