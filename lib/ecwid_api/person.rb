module EcwidApi
  class Person < Entity
    ecwid_reader :name, :companyName, :street, :city, :countryCode,
                 :countryName, :postalCode, :stateOrProvinceCode,
                 :stateOrProvinceName, :phone
  end
end
