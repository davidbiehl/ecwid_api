module EcwidApi
  class Person < Entity
    self.url_root = "persons"

    ecwid_reader :name, :companyName, :street, :city, :countryCode,
                 :countryName, :postalCode, :stateOrProvinceCode,
                 :stateOrProvinceName, :phone
  end
end
