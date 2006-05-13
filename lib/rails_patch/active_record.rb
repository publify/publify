module ActiveRecord
  class Base
    def self.find_boolean(find_type, field, value=true, *options)
      self.find(find_type,
                :conditions => ["#{field} = ?", value], *options)
    end
  end

  # Horrible monkey patch 'til Rails fixes this
  module ConnectionAdapters
    class MysqlAdapter
      def change_column(table_name, column_name, type, options ={ }) #:nodoc:
        if options[:default].nil?
          options[:default] =
            select_one("SHOW COLUMNS FROM #{table_name} LIKE '#{column_name}'")["Default"]
        end
        change_column_sql = "ALTER TABLE #{table_name} CHANGE #{column_name} #{column_name} #{type_to_sql(type, options[:limit])}"
        add_column_options!(change_column_sql, options)
        execute(change_column_sql)
      end
    end

    class SqliteAdapter
      def change_column(table_name, column_name, type, options ={ }) #:nodoc:
        alter_table(table_name) do |definition|
          definition[column_name].instance_eval do
            self.type    = type
            self.limit   = options[:limit] if options[:limit]
            self.default = options[:default] unless options[:default].nil?
          end
        end
      end
    end
  end
end

