class AddsResourcesUpload < ActiveRecord::Migration
  def up
    add_column :resources, :upload, :string
  end

  def down
    remove_column :resources, :upload
  end
end
