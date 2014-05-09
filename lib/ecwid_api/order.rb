module EcwidApi
  # Public: This is an Ecwid Order
  class Order < Entity
    # Public: Gets the unique ID of the order
    def id
      data["number"]
    end

    # Public: Returns the billing person
    def billing_person
      @billing_person ||= Person.new(data["billingPerson"])
    end

    # Public: Returns the shipping person
    def shipping_person
      @shipping_person ||= if data["shippingPerson"]
        Person.new(data["shippingPerson"])
      else
        billing_person
      end
    end

    # Public: Returns a Array of `OrderItem` objects
    def items
      data["items"].map { |item| OrderItem.new(item) }
    end
  end
end