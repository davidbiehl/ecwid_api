require "ecwid_api/version"
require "ext/string"
require 'faraday'
require 'faraday_middleware'

require_relative "ecwid_api/error"

# Public: This is the main namespace for the EcwidApi. It can be used to store
# the default client.
#
module EcwidApi
  require_relative "ecwid_api/o_auth"
  require_relative "ecwid_api/client"
  require_relative "ecwid_api/error"
  require_relative "ecwid_api/api"
  require_relative "ecwid_api/entity"

  require_relative "ecwid_api/category"
  require_relative "ecwid_api/order"
  require_relative "ecwid_api/order_item"
  require_relative "ecwid_api/customer"
  require_relative "ecwid_api/person"
  require_relative "ecwid_api/product_combination"

  require_relative "ecwid_api/product"

  require_relative "ecwid_api/profile"
  require_relative "ecwid_api/storage"
  require_relative "ecwid_api/discount_coupon"
end
