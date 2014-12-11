class AddCoreContentFieldsToContent < ActiveRecord::Migration
  def change
    add_column :contents, :core_content_text, :string
    add_column :contents, :core_content_url, :string
  end
end
