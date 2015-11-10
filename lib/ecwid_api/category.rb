module EcwidApi
  class Category < Entity
    self.url_root = "categories"

    ecwid_reader :id, :parentId, :orderBy, :thumbnailUrl, :originalImageUrl,
                 :name, :url, :productCount, :description, :enabled, :productIds

    ecwid_writer :name, :parentId, :orderBy, :description, :enabled, :productIds

    # Public: Returns an Array of sub categories for the Category
    def sub_categories(params = {})
      @sub_categories ||= client.categories.all(params.merge(parent: id))
    end

    # Public: Returns an Array of all of the sub categories (deep) for the
    #         Category
    def all_sub_categories(params = {})
      @all_sub_categories ||= sub_categories(params) + sub_categories.flat_map do |sub|
        sub.all_sub_categories(params)
      end
    end

    # Public: Returns the parent EcwidApi::Category, or nil if there isn't one
    def parent
      @parent ||= begin
        parent_id = data["parentId"]
        client.categories.find(parent_id) if parent_id
      end
    end

    def parents
      if parent
        parent.parents + [parent]
      else
        []
      end
    end

    # Public: Returns the Products that belong to the Category
    #
    # params - a Hash of values that can be used for a Prdocut search
    #
    # Returns an Enumeration of Products
    def products(params = {})
      @products ||= product_ids.map do |product_id|
        client.products.find(product_id)
      end
    end

    def product_ids
      super || []
    end

    # Public: Uploads an image for the Category
    #
    # filename - a String that is the path to a local file or a URL
    #
    # Returns a Faraday::Response object
    def upload_image!(filename)
      client.post_image("categories/#{id}/image", filename)
    end
  end
end