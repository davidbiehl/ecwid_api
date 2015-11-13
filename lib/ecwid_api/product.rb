module EcwidApi
  # @see http://api.ecwid.com/#products
	class Product < Entity
    self.url_root = "products"

    #####
    # @!group Readonly Attributes
    #####

    # @!attribute [r] id
    #   @return [Integer] the Product ID
    ecwid_reader :id

    # @!attribute [r] in_stock
    #   @return [Boolean] if the product or any combinations are in stock or 
    #     has unlimited quantity
    ecwid_reader :inStock 

    # @!attribute [r] price_in_product_list
    #   @return [Number] price displayed in the Product list.
    ecwid_reader :priceInProductList

    # @!attribute [r] url
    #   @return [String] URL of the product in the store
    ecwid_reader :url

    # @!attribute [r] created
    #   @return [String] Date and time the product was created 
    #     (e.g. 2014-09-30 10:32:38 +0000)
    ecwid_reader :created

    # @!attribute [r] updated
    #   @see {created}
    #   @return [String] Date and time the product was last updated
    ecwid_reader :updated 

    # @!attribute [r] default_combination_id
    #   @return [Integer] the ID of the default Product Combination
    ecwid_reader :defaultCombinationId

    # @!attribute [r] thumbnail_url
    #   Thumbnail size is defined in the store settings
    #   @return [String] the URL of the thumbnail image
    ecwid_reader :thumbnailUrl

    # @!attribute [r] image_url
    #   @return [String] the URL of the Product image resized to 500x500
    ecwid_reader :imageUrl

    # @!attribute [r] small_thumbnail_url
    #   @return [String] the URL of the Product image resized to 80x80
    ecwid_reader :smallThumbnailUrl

    # @!attribute [r] original_image_url
    #   @return [String] the URL of the full-size Product image
    ecwid_reader :originalImageUrl

    # @!attribute [r] gallery_images
    #   @see http://api.ecwid.com/#get-a-product
    #   @todo Make a GalleryImage value object
    #   @return [Array<Hash>] the gallery images
    ecwid_reader :galleryImages

    # @!attribute [r] favorites
    #   @see http://api.ecwid.com/#get-a-product
    #   @todo Make a FavoriteStats value object
    #   @return [Hash] Product favorite stats
    ecwid_reader :favorites

    # @!attribute [r] files
    #   @see http://api.ecwid.com/#get-a-product
    #   @todo Make a ProductFile value object
    #   @return [Array<Hash>] downloadable files (e-goods) attached to the Product
    ecwid_reader :files

    # @!attribute [r] related_products
    #   @see http://api.ecwid.com/#get-a-product
    #   @todo Make a RelatedProducts value object
    #   @return [Hash] related product information
    ecwid_reader :relatedProducts

    # @!attribute [r] combinations
    #   @see #combinations
    #   @todo figure out if this collides with the #combinations API
    #   @return [Array] the Product Combinations
    ecwid_reader :combinations

    #####
    # @!endgroup
    #####

    #####
    # @!group Read/Write Attributes
    #####

    # @!attribute sku
    #   @return [String] the Product's SKU (stock keeping unit)
    ecwid_accessor :sku

    # @!attribute name
    #   @return [String] the name of the Product
    ecwid_accessor :name

    # @!attribute quantity
    #   @note omitted if the product has unlimited stock
    #   @return [Number] the amount of Product in stock
    ecwid_accessor :quantity

    # @!attribute unlimited
    #   @return [Boolean] true if the product has unlimited stock
    ecwid_accessor :unlimited

    # @!attribute price
    #   @return [Number] the price of the Product
    ecwid_accessor :price

    # @!attribute wholesale_prices
    #   @todo create a WholesalePrice value object
    #   @return [Array<Hash>] sorted wholesale price tiers 
    ecwid_accessor :wholesalePrices

    # @!attribute compare_to_price
    #   @note omitted if empty
    #   @return [Number] the sale price displayed in strike-out
    ecwid_accessor :compareToPrice

    # @!attribute weight
    #   @return [Number] the weight of the Product in the units defined in the
    #     store settings
    ecwid_accessor :weight

    # @!attribute product_class_id
    #   0 value means the product is in the General class
    #   @see http://help.ecwid.com/customer/portal/articles/1167365-product-types-and-attributes
    #   @return [Integer] ID of the class (type) that the Product belongs to.
    ecwid_accessor :productClassId

    # @!attribute enabled
    #   @return [Boolean] true if enabled. Disabled products are not displayed
    #     in the store.
    ecwid_accessor :enabled

    # @!attribute options
    #   @todo create a ProductOption value object
    #   @see http://api.ecwid.com/#get-a-product
    #   @return [Array<Hash>] the options for the Product
    ecwid_accessor :options

    # @!attribute warning_limit
    #  When the stock reaches this level, the administrator gets an email
    #  notification.
    #  @return [Number] the minimum warning amount of the Product's stock.
    ecwid_accessor :warningLimit

    # @!attribute fixed_shipping_rate_only
    #   @return [Boolean] true is the shipping cost for the Product is 
    #     calculated as fixed per item.
    ecwid_accessor :fixedShippingRateOnly

    # @!attribute fixed_shipping_rate
    #   @return [Number] when {#fixed_shipping_rate} is true, this is the 
    #     fixed shipping cost for the Product
    ecwid_accessor :fixedShippingRate

    # @!attribute description
    #   @return [String] the Product description in HTML
    ecwid_accessor :description

    # @!attribute category_ids
    #   @return [Array<Integer>] the Category IDs of the Categories that the
    #     Product belongs to
    ecwid_accessor :categoryIds

    # @!attribute default_category_id
    #   @return [Integer] the Category ID of the default category for the 
    #     Product
    ecwid_accessor :defaultCategoryId

    # @!attribute attributes
    #   @see http://api.ecwid.com/#get-a-product
    #   @todo create a AttributeValue value object
    #   @return [Array<Hash>] Product attributes and their values
    ecwid_accessor :attributes

    # @!attribute related_products
    #   @see http://api.ecwid.com/#get-a-product
    #   @todo create a RelatedProduct value object
    #   @return [Hash] Products that are related to this Product
    ecwid_accessor :relatedProducts

    #####
    # @!endgroup
    #####

    # Uploads a primary image for a Product
    #
    # @param filename [String] the path to a local file or URL
    #
    # @return [Faraday::Response] 
    #
    def upload_image!(filename)
      client.post_image("#{url}/image", filename)
    end

    # Uploads gallery images for a Product
    #
    # *filenames [*String] the path to local files or URLs
    #
    # @return [Array<Faraday::Response>]
    #
    def upload_gallery_images!(*filenames)
      filenames.map do |filename|
        client.post_image("#{url}/gallery", filename)
      end
    end

    # Deletes all of the gallery images for a Product
    #
    # @return [Faraday::Response]
    #
    def delete_gallery_images!
      client.delete("#{url}/gallery")
    end

    # Factory method for the {Api::ProductCombinations} API for the Product
    #
    # @see Api::ProductCombinations
    #
    # @return [Api::ProductCombinations]
    #
    def combinations
      @combinations ||= Api::ProductCombinations.new(self, client)
    end

    # The time the Product was created
    #
    # @return [Time]
    def created
      @created ||= Time.parse(super)
    end

    # The time the Product was last updated
    #
    # @return [Time]
    def updated
      @updated ||= Time.parse(super)
    end
	end
end