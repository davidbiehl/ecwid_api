require_relative "../paged_ecwid_response"

module EcwidApi
  module Api
    class DiscountCoupons < Base
      # Public: Get all of the DiscountCoupon objects for the Ecwid store
      #
      # Returns an Array of DiscountCoupon objects
      def all(params = {})
        PagedEcwidResponse.new(client, "discount_coupons", params) do |coupon_hash|
          DiscountCoupon.new(coupon_hash, client: client)
        end
      end

      # Public: Finds a single discount coupon by coupon ID or coupon CODE
      #
      # id - an Ecwid discount coupon ID or CODE
      #
      # Returns a DiscountCoupon object, or nil if one can't be found
      def find(id)
        response = client.get("discount_coupons/#{id}")
        if response.success?
          DiscountCoupon.new(response.body, client: client)
        end
      end

      # Public: Creates a new DiscountCoupon
      #
      # params - a Hash
      #
      # Raises an Error if there is a problem
      #
      # Returns a DiscountCoupon object
      def create(params)
        response = client.post("discount_coupons", params)
        find(response.body["id"])
      end

      # Public: Updates an existing DiscountCoupon
      #
      # id - the Ecwid discount coupon ID or CODE
      # params - a Hash
      #
      # Raises an Error if there is a problem
      #
      # Returns a DiscountCoupon object
      def update(id, params)
        client.put("discount_coupons/#{id}", params)
        find(id)
      end
    end
  end
end