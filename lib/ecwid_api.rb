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
  autoload :ResponseError, "ecwid_api/error"
  autoload :Entity, "ecwid_api/entity"
  autoload :PagedEnumerator, "ecwid_api/paged_enumerator"
  autoload :Api, "ecwid_api/api"

  autoload :Category, "ecwid_api/category"
  autoload :Order, "ecwid_api/order"
  autoload :OrderItem, "ecwid_api/order_item"
  autoload :Person, "ecwid_api/person"

  autoload :Product,    "ecwid_api/product"
end
