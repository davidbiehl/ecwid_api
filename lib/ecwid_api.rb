require "ecwid_api/version"
require "ext/string"
require 'faraday'
require 'faraday_middleware'

# Public: This is the main namespace for the EcwidApi. It can be used to store
# the default client.
#
module EcwidApi
  autoload :Authentication, "ecwid_api/authentication"
  autoload :Client, "ecwid_api/client"
  autoload :Error, "ecwid_api/error"
  autoload :Entity, "ecwid_api/entity"
  autoload :PagedEnumerator, "ecwid_api/paged_enumerator"
  autoload :Api, "ecwid_api/api"

  autoload :CategoryApi, "ecwid_api/category_api"
  autoload :Category, "ecwid_api/category"

  autoload :OrderApi, "ecwid_api/order_api"
  autoload :Order, "ecwid_api/order"
  autoload :OrderItem, "ecwid_api/order_item"
  autoload :Person, "ecwid_api/person"

  autoload :ProductApi, "ecwid_api/product_api"
  autoload :Product,    "ecwid_api/product"

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
