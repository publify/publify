class AddSeoFieldsToContents < ActiveRecord::Migration
  def change
    add_column :contents, :title_meta_tag, :string
    add_column :contents, :description_meta_tag, :string
  end
end
