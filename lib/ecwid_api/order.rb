module EcwidApi
  # Public: This is an Ecwid Order
  class Order < Entity
    VALID_FULFILLMENT_STATUSES = %w(NEW PROCESSING SHIPPED DELIVERED WILL_NOT_DELIVER)
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

    def fulfillment_status=(status)
      status = status.to_s.upcase
      raise Error unless VALID_FULFILLMENT_STATUSES.include?(status)
      @new_fulfillment_status = status
    end

    def shipping_tracking_code=(code)
      @new_shipping_tracking_code = code
    end

    def save
      params = {}
      params[:new_fulfillment_status]     = @new_fulfillment_status     if @new_fulfillment_status
      params[:new_shipping_tracking_code] = @new_shipping_tracking_code if @new_shipping_tracking_code

      if params.keys.any?
        params[:order] = id
        params[:secure_auth_key] = client.order_secret_key
        client.post("orders", params)
      end
    end
  end
end