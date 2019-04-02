module EcwidApi
  class Customer < Entity
    self.url_root = "customers"

    ecwid_reader :id, :email, :name, :totalOrderCount, :customerGroupId, :customerGroupName, :acceptMarketing

    ecwid_writer :email, :name, :acceptMarketing
  end
end