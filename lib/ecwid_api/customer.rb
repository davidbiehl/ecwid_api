module EcwidApi
  class Customer < Entity
    self.url_root = "customers"

    ecwid_reader :id, :email, :name, :totalOrderCount, :customerGroupId, :customerGroupName, 
                 :acceptMarketing, :billingPerson

    ecwid_writer :email, :name, :acceptMarketing

    # Public: Returns the billing person
    #
    def billing_person
      build_billing_person
    end

    private

    def build_billing_person
      @billing_person ||= data["billingPerson"] && Person.new(data["billingPerson"])
    end
  end
end