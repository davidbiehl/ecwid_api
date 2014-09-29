module EcwidApi
  module Api
    class Products < Base
      # Public: Get all of the Product objects for the Ecwid store
      #
      # Returns an Array of Product objects
      def all(params = {})
        response = client.get("products", params)

        PagedEnumerator.new(response) do |response, yielder|
          response.body["items"].each do |item|
            yielder << Product.new(item, client: client)
          end

          count, offset, total = %w(count offset total).map do |i|
            response.body[i].to_i
          end

          if count + offset >= total
            false
          else
            client.get("products", params.merge(offset: offset + count))
          end
        end
      end

      # Public: Finds a single product by product ID
      #
      # id - an Ecwid product ID
      #
      # Returns a Product object, or nil if one can't be found
      def find(id)
        response = client.get("products/#{id}")
        if response.success?
          Product.new(response.body, client: client)
        end
      end

      # Public: Finds a single Product by SKU
      #
      # sku - a SKU of a product
      #
      # Returns a Product object, or nil if one can't be found
      def find_by_sku(sku)
        all(keyword: sku).find { |product| product[:sku] == sku }
      end

      # Public: Creates a new Product
      #
      # params - a Hash
      #
      # Raises an Error if there is a problem
      #
      # Returns a Product object
      def create(params)
        response = client.post("products", params)

        raise_on_failure(response) {|response| find(response.body["id"]) }
      end

      # Public: Updates an existing Product
      #
      # id - the Ecwid product ID
      # params - a Hash
      #
      # Raises an Error if there is a problem
      #
      # Returns a Product object
      def update(id, params)
        response = client.put("products/#{id}", params)

        raise_on_failure(response) { find(id) }
      end
    end
  end
end