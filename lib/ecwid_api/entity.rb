module EcwidApi
  class Entity
    include Api

    # Private: Gets the Hash of data
    attr_reader :data
    protected   :data

    class << self
      attr_accessor :url_root

      def define_accessor(attribute, &block)
        if const_defined?(:Accessors, false)
          mod = const_get(:Accessors)
        else
          mod = const_set(:Accessors, Module.new)
          include mod
        end

        mod.module_eval do
          define_method(attribute, &block)
        end
      end

      private :define_accessor

      # Public: Creates a snake_case access method from an Ecwid property name
      #
      # Example
      #
      #   class Product < Entity
      #     ecwid_reader :id, :inStock
      #   end
      #
      #   product = client.products.find(12)
      #   product.in_stock
      #
      def ecwid_reader(*attrs)
        attrs.map(&:to_s).each do |attribute|
          method = attribute.underscore
          define_accessor(method) do
            self[attribute]
          end unless method_defined?(attribute.underscore)
        end
      end

      # Public: Creates a snake_case writer method from an Ecwid property name
      #
      # Example
      #
      #   class Product < Entity
      #     ecwid_writer :inStock
      #   end
      #
      #   product = client.products.find(12)
      #   product.in_stock = true
      #
      def ecwid_writer(*attrs)
        attrs.map(&:to_s).each do |attribute|
          method = "#{attribute.underscore}="
          define_accessor(method) do |value|
            @new_data[attribute] = value
          end unless method_defined?(method)
        end
      end

      # Public: Creates a snake_case accessor method from an Ecwid property name
      #
      # Example
      #
      #   class Product < Entity
      #     ecwid_accessor :inStock
      #   end
      #
      #   product = client.products.find(12)
      #   product.in_stock
      #   product.in_stock = true
      #
      def ecwid_accessor(*attrs)
        ecwid_reader(*attrs)
        ecwid_writer(*attrs)
      end
    end

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
      @new_data[key.to_s] || data[key.to_s]
    end

    # Public: The URL of the entity
    #
    # Returns a String that is the URL of the entity
    def url
      url_root = self.class.url_root
      raise Error.new("Please specify a url_root for the #{self.class.to_s}") unless url_root

      if url_root.respond_to?(:call)
        url_root = instance_exec(&url_root)
      end

      url_root + "/#{id}"
    end

    # Public: Saves the Entity
    #
    # Saves anything stored in the @new_data hash
    #
    # path - the URL of the entity
    #
    def save
      unless @new_data.empty?
        client.put(url, @new_data).tap do |response|
          raise_on_failure(response)
          @data.merge!(@new_data)
          @new_data.clear
        end
      end
    end

    # Public: Destroys the Entity
    def destroy!
      client.delete(url).tap do |response|
        raise_on_failure(response)
      end
    end

    def to_hash
      data
    end

    def to_json(*args)
      data.to_json(*args)
    end
  end
end