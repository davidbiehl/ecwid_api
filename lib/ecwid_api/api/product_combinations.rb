module EcwidApi
  module Api
    class ProductCombinations < Base
      include Api
      include Enumerable

      attr_reader :product

      def initialize(product, client)
        @product = product
        super(client)
      end

      def all
        response = client.get("products/#{product.id}/combinations")

        if response.success?
          response.body.map do |data|
            ProductCombination.new(data, client: client, product: product)
          end
        end
      end

      def each(&block)
        all = self.all || []

        all.each(&block)
      end

      def find(id)
        response = client.get("products/#{product.id}/combinations/#{id}")

        if response.success?
          ProductCombination.new(response.body, product: product, client: client)
        end
      end

      def create(params)
        response = client.post("products/#{product.id}/combinations", params)

        raise_on_failure(response) { find(response.body["id"]) }
      end

      def delete_all!
        client.delete("products/#{product.id}/combinations").tap do |response|
          raise_on_failure(response)
        end
      end
    end
  end
end