module EcwidApi
  class ProductApi < Api
    # Public: Get all of the Product objects for the Ecwid store
    #
    # Returns an Array of Product objects
    def all(params = {})
      @all ||= {}
      @all[params] ||= begin
        params[:secure_auth_key] = client.product_secret_key

        response = client.get("products", params)
        response.body.map { |hash| Product.new(hash, client: client) }
      end
    end

    # Public: Finds a single product by SKU
    #
    # sku - a String that represents a SKU
    #
    # Returns a Product object, or nil if one can't be found
    def find(sku)
      all.find { |product| product[:sku] == sku }
    end
  end
end