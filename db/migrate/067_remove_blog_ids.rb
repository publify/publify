class RemoveBlogIds < ActiveRecord::Migration
  class Content < ActiveRecord::Base
    set_inheritance_column :bogustype
  end

  class Feedback < ActiveRecord::Base
    set_table_name "feedback"
  end

  class Sidebar < ActiveRecord::Base
  end

  def self.up
    if adapter_name == 'PostgreSQL'
      indexes(:contents).each do |index|
        if index.name =~ /blog_id/
          remove_index(:contents, :name => index.name)
        end
      end
    else
      remove_index :contents, :blog_id rescue nil
    end
    remove_column :contents, :blog_id
    remove_column :sidebars, :blog_id
    remove_column :feedback, :blog_id
  end

  def self.down
    add_column :contents, :blog_id, :integer
    add_column :sidebars, :blog_id, :integer
    add_column :feedback, :blog_id, :integer

    default_blog_id = Blog.find(:first, :order => 'id').id

    Content.update_all("blog_id = #{default_blog_id}")
    Feedback.update_all("blog_id = #{default_blog_id}")
    Sidebar.update_all("blog_id = #{default_blog_id}")

    change_column :sidebars, :blog_id, :integer, :null => false

    add_index :contents, :blog_id
  end
end
