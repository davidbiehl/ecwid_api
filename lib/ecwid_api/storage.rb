module EcwidApi
  class Storage < Entity
    self.url_root = "storage"

    def [](key)
      find_storage_key(data, key.to_s)
    end

    def set!(key, value)
      client.put(prop_url(key), value).tap do |response|
        update_storage_key(key.to_s, value)
      end

      true
    end

    def delete!(key)
      return false unless self[key].present?

      client.delete(prop_url(key)).tap do |response|
        delete_storage_key(key.to_s)
      end

      true
    end

    def []=(key, value)
      raise NotImplementedError.new("Use `#set!(key, val)` method instead.")
    end

    # Public: Save is not implemented for Storage
    def save
      raise NotImplementedError.new("Use `#set!(key, val)` method instead.")
    end

    # Public: Destroy is not implemented for Storage
    def destroy!
      raise NotImplementedError.new("Use `#delete!(key)` method instead.")
    end

    private

    def prop_url(key)
      url_root = self.class.url_root
      raise Error.new("Please specify a url_root for the #{self.class.to_s}") unless url_root

      if url_root.respond_to?(:call)
        url_root = instance_exec(&url_root)
      end

      url_root + "/#{key}"
    end

    def find_storage_key(data_attribute, key)
      found_kv = data_attribute.detect { |da| da["key"] == key }
      found_kv ? found_kv["value"] : nil
    end

    def update_storage_key(key, value)
      updated = false

      @data = data.map do |entry| 
        if entry["key"] == key
          updated = true
          entry.merge({"value" => value})
        else
          entry
        end
      end

      @data.append({"key" => key, "value" => value}) unless updated
    end

    def delete_storage_key(key)
      @data.delete_if { |entry| entry["key"] == key }
    end
  end
end
