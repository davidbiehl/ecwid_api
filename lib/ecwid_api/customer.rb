module EcwidApi
  class Customer < Entity
    self.url_root = "customers"

    ecwid_reader :id, :email, :name, :totalOrderCount, :customerGroupId, :customerGroupName, :acceptMarketing
  end
end