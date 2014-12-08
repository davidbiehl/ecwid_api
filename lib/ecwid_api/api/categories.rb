module EcwidApi
  module Api
    class Categories < Base
      # Public: Returns all of the sub-categories for a given category
      #
      # See: http://kb.ecwid.com/w/page/25285101/Product%20API#RESTAPIMethodcategories
      #
      # parent - The Category ID of the parent category. If the parent is 0 then
      #          a list of the root categories will be returned. If the parent is
      #          nil, then all of the categories will be returned
      #
      # Returns an array of EcwidApi::Category objects
      def all(params = {})
        response = client.get("categories", params)

        if response.success?
          response.body
        else
          []
        end.map {|category| Category.new(category, client: client) }.sort_by(&:order_by)
      end

      # Public: Returns an Array of the root level EcwidApi::Category objects
      def root(params = {})
        all(params.merge(parent: 0))
      end

      # Public: Returns a single EcwidApi::Category
      #
      # See: http://kb.ecwid.com/w/page/25285101/Product%20API#RESTAPIMethodcategory
      #
      # category_id - A Category ID to get
      #
      # Returns an EcwidApi::Category, or nil if it can't be found
      def find(id)
        response = client.get("categories/#{id}")

        if response.success?
          Category.new(response.body, client: client)
        else
          nil
        end
      rescue Zlib::BufError
        nil
      end

      # Public: Creates a new Category
      #
      # params - a Hash of API keys and their corresponding values
      #
      # Returns a new Category entity
      def create(params)
        response = client.post("categories", params)

        raise_on_failure(response) { |response| find(response.body["id"]) }
      end
    end
  end
end