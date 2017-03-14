module EcwidApi
  class Customer < Entity
    self.url_root = "customers"

    ecwid_reader :name, :email, :totalOrderCount, :customerGroupId, :customerGroupName

    ecwid_writer :name, :email

  end
end
