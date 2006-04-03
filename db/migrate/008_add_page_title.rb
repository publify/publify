class AddPageTitle < ActiveRecord::Migration
  def self.up
    add_column :pages, :title, :string
  end

  def self.down
    remove_column :pages, :title
  end
end
