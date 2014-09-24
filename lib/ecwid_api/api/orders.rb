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
        params[:limit]           = 100
        params.delete(:offset)

        response = client.get("orders", params)

        PagedEnumerator.new(response) do |response, yielder|
          response.body["orders"].each do |data|
            order = Order.new(data, client: client)
            yielder << order
          end

          next_url = response.body["nextUrl"]
          next_url ? client.get(next_url) : false
        end
      end

      def find(order_id)
        all(order: order_id).first
      end
    end
  end
end
