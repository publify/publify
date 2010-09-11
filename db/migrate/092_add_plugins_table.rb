class AddPluginsTable < ActiveRecord::Migration
  def self.up
    create_table :plugin_entries do |t|
      t.string  :kind,        :null => false
      t.string  :name,        :null => false
      t.string  :klass,       :null => false
      t.boolean :active,      :null => false, :default => true
      t.string  :description, :null => true
    end
  end

  def self.down
    drop_table :plugins
  end
end
