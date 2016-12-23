class DemandBlogIdOnContents < ActiveRecord::Migration[4.2]
  def up
    change_column :contents, :blog_id, :integer, null: false
  end

  def down
    change_column :contents, :blog_id, :integer, null: true
  end
end
