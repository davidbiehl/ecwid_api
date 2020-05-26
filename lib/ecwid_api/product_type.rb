module EcwidApi
	class ProductType < Entity
    self.url_root = "classes"

    ecwid_reader :id, :attributes, :name, :googleTaxonomy

    ecwid_writer :attributes, :name
	end
end