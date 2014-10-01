module EcwidApi
  class Entity
    # Private: Gets the Hash of data
    attr_reader :data
    private     :data

    # Public: Initialize a new entity with a reference to the client and data
    #
    # data   - A Hash of data that represents the properties of this Entity
    # opts   - A Hash of options
    #          :client - The EcwidApi::Client creating the Entity
    #
    def initialize(data, opts={})
      @client, @data = opts[:client], data
      @new_data = {}
    end

    # Public: Returns a property of the data (actual property name)
    #
    # key - A Symbol or String of the property. The key should be the actual
    #       key according to the Ecwid API documentation for the given entity.
    #       Typically, this is camel cased.
    #
    # Examples
    #
    #   entity[:parentId]
    #   entity["parentId"]
    #
    # Returns the value of the property, or nil if it doesn't exist
    def [](key)
      data[key.to_s]
    end

    # Public: Get a property of the data (snake_case)
    #
    # This is used as a helper to allow easy access to the data. It will work
    # with both CamelCased and snake_case keys. For example, if the data
    # contains a "parentId" key, then calling `entity.parent_id` should work.
    #
    # This will NOT return null of the property doesn't exist on the data!
    #
    # Examples
    #
    #   entity.parent_id    # same as `entity["parentId"]`
    #
    # TODO: #method_missing isn't the ideal solution because Ecwid will only
    # return a property if it doesn't have a null value. An example of this are
    # the top level categories. They don't have a parentId, so that property
    # is ommitted from the API response. Calling `category.parent_id` will
    # result in an "undefined method `parent_id'". However, calling `#parent_id`
    # on any other category will work.
    #
    # Returns the value of the property
    def method_missing(method, *args)
      method_string = method.to_s

      [ method_string, method_string.camel_case ].each do |key|
        return data[key] if data.has_key?(key)
      end

      super method, *args
    end
  end
end