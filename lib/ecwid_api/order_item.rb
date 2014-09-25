module EcwidApi
  class OrderItem < Entity
    include Api

    # Public: Returns the default `Category` that the product belongs to
    def category
      client.categories.find(data["categoryId"])
    end

    # TODO: get the product
  end
end