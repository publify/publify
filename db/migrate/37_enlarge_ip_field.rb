class EnlargeIpField < ActiveRecord::Migration
  def self.up
    change_column :contents, :ip, :string, :limit => 40
  end

  def self.down
    change_column :contents, :ip, :string
  end
end
