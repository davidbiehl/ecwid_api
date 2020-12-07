module EcwidApi
  class ProductTypeAttribute < Entity

    ecwid_reader :id, :name, :type, :show

    VALID_TYPES = %w(CUSTOM UPC BRAND GENDER AGE_GROUP COLOR SIZE PRICE_PER_UNIT UNITS_IN_PRODUCT)
    VALID_SHOWS = %w(NOTSHOW DESCR PRICE)


    def type=(type_type)
      type_type = type_type.to_s.upcase
      unless VALID_TYPES.include?(type_type)
        raise ::StandardError.new("#{type_type} is an invalid 'type'")
      end
      super(type_type)
    end


    def show=(show_type)
      show_type = show_type.to_s.upcase
      unless VALID_SHOWS.include?(show_type)
        raise ::StandardError.new("#{show_type} is an invalid 'show'")
      end
      super(show_type)
    end

  end
end
