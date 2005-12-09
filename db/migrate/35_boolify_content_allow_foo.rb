class BoolifyContentAllowFoo < ActiveRecord::Migration
  class << self
    def boolify_field(fieldname, options={})
      Content.transaction do
        rename_column :contents, fieldname, "old_#{fieldname}"
        add_column :contents, fieldname, :boolean, options
        
        if not $schema_generator
          STDERR.puts "Boolifying #{fieldname}"
          Content.connection.select_all(%{
          SELECT
            id, old_#{fieldname} as oldval
          FROM contents}).each do |res|
            if !res["oldval"].nil?
              c = Content.find(res["id"])
              c.update_attribute(fieldname, !res["oldval"].to_i.zero?)
            end
          end
        end
        remove_column :contents, "old_#{fieldname}"
      end
    end

    def up
      STDERR.puts "Boolifying contents.allow_(comments|pings)"
      boolify_field "allow_comments"
      boolify_field "allow_pings"
      
    end
    def self.down
      raise "Can't downgrade"
    end
  end
end
