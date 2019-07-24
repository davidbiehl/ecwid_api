require_relative "../paged_ecwid_response"

module EcwidApi
  module Api
    class Products < Base
      # Public: Get all of the Product objects for the Ecwid store
      # params - a hash of request parameters. Parameters can be
      #   keyword                     string            Search term. Use quotes to search for exact match. 
      #                                                 Ecwid searches products over multiple fields:
      #                                                   * title
      #                                                   * description
      #                                                   * SKU
      #                                                   * product options
      #                                                   * category name
      #                                                   * gallery image descriptions
      #                                                   * attribute values (except for hidden attributes). 
      #                                                     If your keywords contain special characters, 
      #                                                     it may make sense to URL encode them before making a request
      #   priceFrom                   number            Minimum product price
      #   priceTo                     number            Maximum product price
      #   category                    number            Category ID. To get Store Front Page products, specify `&category=0` in the request
      #   withSubcategories           boolean           `true/false`: defines whether Ecwid should search in subcategories of the 
      #                                                 category you set in `category` field. Ignored if `category` field is not set.
      #                                                 `false` is the default value
      #   sortBy                      string            Sort order. Supported values:
      #                                                   * `RELEVANCE` default
      #                                                   * `DEFINED_BY_STORE_OWNER`
      #                                                   * `ADDED_TIME_DESC`
      #                                                   * `ADDED_TIME_ASC`
      #                                                   * `NAME_ASC`
      #                                                   * `NAME_DESC`
      #                                                   * `PRICE_ASC`
      #                                                   * `PRICE_DESC`
      #                                                   * `UPDATED_TIME_ASC`
      #                                                   * `UPDATED_TIME_DESC`
      #                                                 . If request is applicable to a specific category (i.e. `category` is set), 
      #                                                 then `DEFINED_BY_STORE_OWNER` sort method is used
      #   offset                      number            Offset from the beginning of the returned items list (for paging)
      #   limit                       number            Maximum number of returned items. Maximum allowed value: `100`. Default value: `100`
      #   createdFrom                 string            Product creation date/time (lower bound). Supported formats:
      #                                                   * UNIX timestamp
      #                                                 Examples:
      #                                                   * `1447804800`
      #   createdTo                   string            Product creation date/time (upper bound). Supported formats:
      #                                                   * UNIX timestamp
      #   updatedFrom                 string            Product last update date/time (lower bound). Supported formats:
      #                                                   * UNIX timestamp
      #   updatedTo                   string            Product last update date/time (upper bound). Supported formats:
      #                                                   * UNIX timestamp
      #   enabled                     boolean           `true` to get only enabled products, `false` to get only disabled products
      #   inStock                     boolean           `true` to get only products in stock, `false` to get out of stock products
      #   sku                         string            Product or variation SKU. Ecwid will return details of a product containing that SKU, 
      #                                                 if SKU value is an exact match. If SKU is specified, other search parameters are ignored, 
      #                                                 except for product ID.
      #   productId                   number            Internal Ecwid product ID or multiple productIds separated by a comma. If this field is 
      #                                                 specified, other search parameters are ignored.
      #   baseUrl                     string            Storefront URL for Ecwid to use when returning product URLs in the url field. 
      #                                                 If not specified, Ecwid will use the storefront URL specified in the store settings
      #   cleanUrls                   boolean           If `true`, Ecwid will return the SEO-friendly clean URL (without hash `'#'`) in the `url` field. 
      #                                                 If `false`, Ecwid will return URL in the old format (with hash `'#'`). We recommend using 
      #                                                 `true` value if merchant’s website supports clean SEO-friendly URL feature
      #   onsale                      string            Use `"onsale"` to get on sale items only or `"notonsale"` for items not currently on sale.
      #   option_{optionName}         string            Filter by product option values. Format: `option_{optionName}=param[,param]`, 
      #                                                 where optionName is the attribute name and param is the attribute value. 
      #                                                 You can place several values separated by comma. In that case, values will be connected 
      #                                                 through logical “OR”, and if the product has at least one of them it will get to the 
      #                                                 search results. Example:
      #                                                   `option_Size=S,M,L&option_Color=Red,Black`
      #   attribute_{attributeName}   string            Filter by product attribute values. Format: `attribute_{attributeName}=param[,param]`, 
      #                                                 where attributeName is the attribute name and param is the attribute value. 
      #                                                 You can place several values separated by comma. In that case, values will be connected 
      #                                                 through logical “OR”, and if the product has at least one of them it will get to the 
      #                                                 search results. Example:
      #                                                   `attribute_Brand=Apple&attribute_Capacity=32GB,64GB`
      #   lang                        string            Preferred language for the product fields in search results. 
      #                                                 If a certain field does not have the translation available for the set language, 
      #                                                 the default language text will be used for that field.
      # Returns an Array of Product objects
      def all(params = {})
        PagedEcwidResponse.new(client, "products", params) do |product_hash|
          Product.new(product_hash, client: client)
        end
      end

      # Public: Finds a single product by product ID
      #
      # id - an Ecwid product ID
      # params - a hash of request parameters. Parameters can be
      #   baseUrl                     string            Storefront URL for Ecwid to use when returning product URLs in the url field. 
      #                                                 If not specified, Ecwid will use the storefront URL specified in the 
      #   cleanUrls                   boolean           If `true`, Ecwid will return the SEO-friendly clean URL (without hash '#') 
      #                                                 in the url field. If `false`, Ecwid will return URL in the old format (with hash '#'). 
      #                                                 We recommend using `true` value if merchant’s website supports clean
      #   lang                        string            Preferred language for the product fields in search results. If a certain field does 
      #                                                 not have the translation available for the set language, the default language text 
      #                                                 will be used for that field.
      # Returns a Product object, or nil if one can't be found
      def find(id, params = {})
        response = client.get("products/#{id}", params)
        if response.success?
          Product.new(response.body, client: client)
        end
      end

      # Public: Finds a single Product by SKU
      #
      # sku - a SKU of a product
      # params - a hash of request parameters. Parameters can be
      #   baseUrl                     string            Storefront URL for Ecwid to use when returning product URLs in the url field. 
      #                                                 If not specified, Ecwid will use the storefront URL specified in the 
      #   cleanUrls                   boolean           If `true`, Ecwid will return the SEO-friendly clean URL (without hash '#') 
      #                                                 in the url field. If `false`, Ecwid will return URL in the old format (with hash '#'). 
      #                                                 We recommend using `true` value if merchant’s website supports clean
      #   lang                        string            Preferred language for the product fields in search results. If a certain field does 
      #                                                 not have the translation available for the set language, the default language text 
      #                                                 will be used for that field.      
      # Returns a Product object, or nil if one can't be found
      def find_by_sku(sku, params = {})
        all(params.merge(keyword: sku)).find { |product| product[:sku] == sku }
      end

      # Public: Creates a new Product
      #
      # params - a Hash
      #
      # Raises an Error if there is a problem
      #
      # Returns a Product object
      def create(params)
        response = client.post("products", params)
        find(response.body["id"])
      end

      # Public: Updates an existing Product
      #
      # id - the Ecwid product ID
      # params - a Hash
      #
      # Raises an Error if there is a problem
      #
      # Returns a Product object
      def update(id, params)
        client.put("products/#{id}", params)
        find(id)
      end
    end
  end
end