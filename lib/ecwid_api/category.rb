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

    def product_ids=(product_ids)
      @new_data[:productIds] = product_ids
    end

    def save
      unless @new_data.empty?
        client.put("categories/#{id}", @new_data).tap do |response|
          raise_on_failure(response)
          @data.merge!(@new_data)
          @new_data.clear
        end
      end
    end
  end
end