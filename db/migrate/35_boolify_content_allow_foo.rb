class BoolifyContentAllowFoo < ActiveRecord::Migration
  class << self
    def up
      STDERR.puts "Boolifying contents.allow_(comments|pings)"
      Content.transaction do
        rename_column :contents, :allow_pings, :old_ap
        add_column :contents, :allow_pings, :boolean
        rename_column :contents, :allow_comments, :old_ac
        add_column :contents, :allow_comments, :boolean
        
        if not $schema_generator
          Content.connection.select_all(%{
          SELECT
            id, old_ap, old_ac
          FROM contents}).each do |res|
            if !res["oldval"].nil?
              c = Content.find(res["id"])
              c.allow_pings = !res["old_ap"].to_i.zero?
              c.allow_comments = !res["old_ac"].to_i.zero?
              c.save
            end
          end
        end
        remove_column :contents, :old_ap
        remove_column :contents, :old_ac
      end
    end
    def self.down
      raise "Can't downgrade"
    end
  end
end
