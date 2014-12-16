class AddRelatedContentIdsToContents < ActiveRecord::Migration
  def change
    add_column :contents, :primary_related_content_id, :integer
    add_column :contents, :secondary_related_content_id, :integer
  end
end
