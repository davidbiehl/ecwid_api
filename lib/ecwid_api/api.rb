module EcwidApi
  # Internal: A base class for common API functionality
  module Api
    autoload :Base,       "ecwid_api/api/base"
    autoload :Orders,     "ecwid_api/api/orders"
    autoload :Products,   "ecwid_api/api/products"
    autoload :Categories, "ecwid_api/api/categories"
  end
end