module EcwidApi
  class ProductType < Entity
    self.url_root = "classes"

    ecwid_reader :id, :name, :googleTaxonomy, :attributes

    ecwid_writer :name, :attributes


    # Public: Returns a Array of `ProductTypeAttribute` objects
    def attributes
      @attributes ||= data["attributes"].map { |attribute| ProductTypeAttribute.new(attribute) }
    end


  end
end
