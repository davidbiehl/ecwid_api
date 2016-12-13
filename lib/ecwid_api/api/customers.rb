require_relative "../paged_ecwid_response"

module EcwidApi
  module Api
    class Customers < Base
      # Public: Get all of the Customer objects for the Ecwid store
      #
      # Returns an Array of Customer objects
      def all(params = {})
        PagedEcwidResponse.new(client, "customers", params) do |customer_hash|
          Customer.new(customer_hash, client: client)
        end
      end

      # Public: Finds a single customer by customer ID
      #
      # id - an Ecwid customer ID
      #
      # Returns a Customer object, or nil if one can't be found
      def find(id)
        response = client.get("customers/#{id}")
        if response.success?
          Customer.new(response.body, client: client)
        end
      end

      # Public: Finds a single Customer by email
      #
      # email - an email of a customer
      #
      # Returns a Customer object, or nil if one can't be found
      def find_by_email(email)
        all(email: email).first
      end

      # Public: Creates a new Customer
      #
      # params - a Hash
      #
      # Raises an Error if there is a problem
      #
      # Returns a Customer object
      def create(params)
        response = client.post("customers", params)
        find(response.body["id"])
      end

      # Public: Updates an existing Customer
      #
      # id - the Ecwid customer ID
      # params - a Hash
      #
      # Raises an Error if there is a problem
      #
      # Returns a Customer object
      def update(id, params)
        client.put("customers/#{id}", params)
        find(id)
      end
    end
  end
end