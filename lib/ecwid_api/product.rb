require "open-uri"

module EcwidApi
	class Product < Entity
    self.url_root = "products"

    ecwid_reader :id, :sku, :quantity, :unlimited, :inStock, :name, :price,
                 :priceInProductList, :wholesalePrices, :compareToPrice,
                 :weight, :url, :created, :updated, :productClassId,
                 :enabled, :options, :warningLimit, :fixedShippingRateOnly,
                 :fixedShippingRate, :defaultCombinationId, :thumbnailUrl,
                 :imageUrl, :smallThumbnailUrl, :originalImageUrl, :description,
                 :galleryImages, :categoryIds, :defaultCategoryId, :favorites,
                 :attributes, :files, :relatedProducts, :combinations

    ecwid_writer :sku, :name, :quantity, :price, :wholesalePrices,
                 :compareToPrice, :weight, :productClassId, :enabled, :options,
                 :warningLimit, :fixedShippingRateOnly, :fixedShippingRate,
                 :description, :categoryIds, :defaultCategoryId, :attributes,
                 :relatedProducts

    # Public: Uploads a primary image for a Product
    #
    # filename - a String that is either a local file name or URL
    #
    # Raises ResponseError if the API returns an error
    #
    # Returns a Faraday::Response object
    def upload_image!(filename)
      client.post("#{url}/image") do |req|
        req.body = open(filename).read
      end.tap do |response|
        raise_on_failure(response)
      end
    end

    # Public: Uploads gallery images for a Product
    #
    # *filenames - Strings that are either a local file name or URL
    #
    # Raises ResponseError if the API returns an error
    #
    # Returns an Array of Faraday::Response object
    def upload_gallery_images!(*filenames)
      filenames.map do |filename|
        client.post("#{url}/gallery") do |req|
          req.body = open(filename).read
        end.tap do |response|
          raise_on_failure(response)
        end
      end
    end

    # Public: Deletes all of the gallery images for a Product
    #
    # Raises ResponseError if the API returns an error
    #
    # Returns a Faraday::Response object
    def delete_gallery_images!
      client.delete("#{url}/gallery").tap do |response|
        raise_on_failure(response)
      end
    end

    def combinations
      @combinations ||= Api::ProductCombinations.new(self, client)
    end

    def created
      @created ||= Time.parse(super)
    end

    def updated
      @updated ||= Time.parse(super)
    end
	end
end