module EcwidApi
  class DiscountCoupon < Entity
    self.url_root = "discount_coupons"

    ecwid_reader :id, :name, :code, :discountType, :status, :discount, :launchDate, :usesLimit, 
                 :applicationLimit, :creationDate, :updateDate, :orderCount, :catalogLimit

    ecwid_writer :name, :code, :discountType, :status, :discount, :launchDate, :usesLimit, 
                 :applicationLimit, :catalogLimit
  end
end
