module ActiveRecord
  # Convenience method.
  # TODO: Replace calls by find_by_boolean_field_name(value)
  class Base
    def self.find_boolean(find_type, field, value=true, *options)
      self.find(find_type,
                :conditions => ["#{field} = ?", value], *options)
    end
  end
end
