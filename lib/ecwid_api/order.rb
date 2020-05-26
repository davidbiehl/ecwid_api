module EcwidApi
  # Public: This is an Ecwid Order
  class Order < Entity
    self.url_root = "orders"

    ecwid_reader :orderNumber, :vendorOrderNumber, :subtotal, :total, :email,
                 :paymentMethod, :paymentModule, :tax, :ipAddress,
                 :couponDiscount, :paymentStatus, :fulfillmentStatus,
                 :refererUrl, :orderComments, :volumeDiscount, :customerId,
                 :membershipBasedDiscount, :totalAndMembershipBasedDiscount,
                 :discount, :usdTotal, :globalReferer, :createDate, :updateDate,
                 :customerGroup, :discountCoupon, :items, :billingPerson,
                 :shippingPerson, :shippingOption, :additionalInfo,
                 :paymentParams, :discountInfo, :trackingNumber,
                 :paymentMessage, :extTransactionId, :affiliateId,
                 :creditCardStatus, :acceptMarketing


    ecwid_writer :subtotal, :total, :email, :paymentMethod, :paymentModule,
                 :tax, :ipAddress, :couponDiscount, :paymentStatus,
                 :fulfillmentStatus, :refererUrl, :orderComments,
                 :volumeDiscount, :customerId, :membershipBasedDiscount,
                 :totalAndMembershipBasedDiscount, :discount, :globalReferer,
                 :createDate, :updateDate, :customerGroup, :discountCoupon,
                 :items, :billingPerson, :shippingPerson, :shippingOption,
                 :additionalInfo, :paymentParams, :discountInfo,
                 :trackingNumber, :paymentMessage, :extTransactionId,
                 :affiliateId, :creditCardStatus

    VALID_FULFILLMENT_STATUSES = %w(
      AWAITING_PROCESSING
      PROCESSING
      SHIPPED
      DELIVERED
      WILL_NOT_DELIVER
      RETURNED
    )

    # Public: Gets the unique ID of the order
    def id
      order_number
    end

    # Public: Returns the billing person
    #
    # If there isn't a billing_person, then it assumed to be the shipping_person
    #
    def billing_person
      build_billing_person || build_shipping_person
    end

    # Public: Returns the shipping person
    #
    # If there isn't a shipping_person, then it is assumed to be the 
    # billing_person
    #
    def shipping_person
      build_shipping_person || build_billing_person
    end

    # Public: Returns a Array of `OrderItem` objects
    def items
      @items ||= data["items"].map { |item| OrderItem.new(item) }
    end

    def fulfillment_status=(status)
      status = status.to_s.upcase
      unless VALID_FULFILLMENT_STATUSES.include?(status)
        raise Error.new("#{status} is an invalid fullfillment status")
      end
      super(status)
    end

    def fulfillment_status
      super && super.downcase.to_sym
    end

    private

    def build_billing_person
      @billing_person ||= data["billingPerson"] && Person.new(data["billingPerson"])
    end

    def build_shipping_person
      @shipping_person ||= data["shippingPerson"] && Person.new(data["shippingPerson"])
    end
  end
end