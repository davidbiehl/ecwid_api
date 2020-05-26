require_relative "../paged_ecwid_response"

module EcwidApi
  module Api
    class ProductTypes < Base
      # Public: Get all of the ProductType objects for the Ecwid store
      #
      # Returns an Array of ProductType objects
      def all(params = {})
        response = client.get("classes")
        return response.body.map do |product_type_hash|
          ProductType.new(product_type_hash, client: client)          
        end
      end

      # Public: Finds a single product_type by product_type ID
      #
      # id - an Ecwid product_type ID
      #
      # Returns a ProductType object, or nil if one can't be found
      def find(id)
        response = client.get("classes/#{id}")
        if response.success?
          ProductType.new(response.body, client: client)
        end
      end

      # Public: Creates a new ProductType
      #
      # params - a Hash
      #
      # Raises an Error if there is a problem
      #
      # Returns a ProductType object
      def create(params)
        response = client.post("classes", params)
        find(response.body["id"])
      end

      # Public: Updates an existing ProductType
      #
      # id - the Ecwid product_type ID
      # params - a Hash
      #
      # Raises an Error if there is a problem
      #
      # Returns a ProductType object
      def update(id, params)
        client.put("classes/#{id}", params)
        find(id)
      end
    end
  end
end