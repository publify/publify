class AddSitealizerPlugin < ActiveRecord::Migration

  def self.up
    create_table :sitealizer do |t|
      t.column :path,           :string
      t.column :ip,             :string
      t.column :referer,        :string
      t.column :language,       :string
      t.column :user_agent,     :string
      t.column :created_at,     :datetime
      t.column :created_on,     :date
    end
  end

  def self.down
    drop_table :sitealizer
  end
end
