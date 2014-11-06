module EcwidApi
  class OrderItem < Entity
    ecwid_reader :id, :productId, :categoryId, :price, :productPrice, :weight,
                 :sku, :quantity, :shortDescription, :tax, :shipping,
                 :quantityInStock, :name, :tangible, :trackQuantity,
                 :fixedShippingRateOnly, :imageId, :fixedShippingRate,
                 :digital, :productAvailable, :couponApplied, :selectedOptions,
                 :taxes, :files

    # Public: Returns the default `Category` that the product belongs to
    def category
      client.categories.find(data["categoryId"])
    end

    # TODO: get the product
  end
end