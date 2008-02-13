ActiveRecord.module_eval do
  class Base
    private
    def attributes_with_quotes(include_primary_key = true, include_readonly_attributes = true)
      quoted = {}
      @attributes.each_key do |name|
        if column = column_for_attribute(name)
          unless (!include_primary_key && column.primary) ||
            (!include_readonly_attributes && self.class.readonly_attributes && self.class.readonly_attributes.include?(name.gsub(/\(.+/,"")))
            quoted[name] = quote_value(read_attribute(name), column)
          end
        end
      end
      quoted
    end
  end
end
