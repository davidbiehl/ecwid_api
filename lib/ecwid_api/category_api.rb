module EcwidApi
  # Public: This is the Ecwid API for Categories. It abstracts the end-points
  # of the Ecwid API that deal with categories.
  class CategoryApi
    # Private: Gets the Client
    attr_reader :client
    private     :client

    # Public: Initializes a new EcwidApi::CategoryApi
    #
    # client - The EcwidApi::Client to use with the API
    #
    def initialize(client = EcwidApi.default_client)
      @client = client
      raise Error.new("The client cannot be nil") unless client
    end

    # Public: Returns all of the sub-categories for a given category
    #
    # See: http://kb.ecwid.com/w/page/25285101/Product%20API#RESTAPIMethodcategories
    #
    # parent - The Category ID of the parent category. If the parent is 0 then
    #          a list of the root categories will be returned. If the parent is
    #          nil, then all of the categories will be returned
    #
    # Returns an array of EcwidApi::Category objects
    def all(parent = nil)
      params = {}
      params[:parent] = parent if parent

      response = client.get("categories", params)

      if response.success?
        response.body
      else
        []
      end.map {|category| Category.new(category, client: client) }
    end

    # Public: Returns an Array of the root level EcwidApi::Category objects
    def root
      all(0)
    end

    # Public: Returns a single EcwidApi::Category
    #
    # See: http://kb.ecwid.com/w/page/25285101/Product%20API#RESTAPIMethodcategory
    #
    # category_id - A Category ID to get
    #
    # Returns an EcwidApi::Category, or nil if it can't be found
    def find(category_id)
      response = client.get("category", id: category_id)

      if response.success?
        Category.new(response.body, client: client)
      else
        nil
      end
    end
  end
end