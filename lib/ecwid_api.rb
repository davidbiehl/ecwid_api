require "ecwid_api/version"

# Public: This is the main namespace for the EcwidApi. It can be used to store
# the default client.
#
module EcwidApi
  autoload :Client, "ecwid_api/client"
  autoload :Error, "ecwid_api/error"

  class << self
    # Public: Gets and configures a default client
    #
    # To configure the default client, just pass a block.
    #
    # Examples
    #
    #   EcwidApi.default_client do |config|
    #     config.store_id = '12345'
    #     config.order_secret_key = 'ORDER_SECRET_KEY'
    #     config.product_secret_key = 'PRODUCT_SECRET_KEY'
    #   end
    #
    #   client = EcwidApi.default_client.store_id
    #   # => "12345"
    #
    # Returns an EcwidApi::Client, or null if one hasn't been configured
    def default_client(&block)
      if block_given?
        @default_client = Client.new(&block)
      end
      @default_client
    end
  end
end
