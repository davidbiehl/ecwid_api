module EcwidApi
  class Category < Entity
    include Api

    # Public: Returns an Array of sub categories for the Category
    def sub_categories(params = {})
      @sub_categories ||= client.categories.all(params.merge(parent: id))
    end

    # Public: Returns the parent EcwidApi::Category, or nil if there isn't one
    def parent
      parent_id = data["parentId"]
      client.categories.find(parent_id) if parent_id
    end
  end
end