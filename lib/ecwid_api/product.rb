require "open-uri"

module EcwidApi
	class Product < Entity
    include Api

    # Public: Uploads a primary image for a Product
    #
    # filename - a String that is either a local file name or URL
    #
    # Raises ResponseError if the API returns an error
    #
    # Returns a Faraday::Response object
    def upload_image!(filename)
      client.post("#{api_uri}/image") do |req|
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
        client.post("#{api_uri}/gallery") do |req|
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
      client.delete("#{api_uri}/gallery").tap do |response|
        raise_on_failure(response)
      end
    end

    def combinations
      @combinations ||= Api::ProductCombinations.new(self, client)
    end

    private

    def api_uri
      "products/#{id}"
    end
	end
end