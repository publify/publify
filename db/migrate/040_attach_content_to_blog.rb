class AttachContentToBlog < ActiveRecord::Migration
  class Bare40Content < ActiveRecord::Base
    include BareMigration
  end

  class Bare40Blog < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    begin
      add_column :contents, :blog_id, :integer
      blog_id = Bare40Blog.find(:first).id

      # FIXME: Wrap these two lines and put them in bare_migration.rb
      Bare40Content.reset_column_information
      Bare40Content.inheritance_column = :ignore_inheritance_column

      Bare40Content.find(:all).each {|c| c.blog_id = blog_id; c.save! }
      change_column :contents, :blog_id, :integer, :null => false
      add_index :contents, :blog_id
    rescue Exception => e
      remove_index :contents, :blog_id rescue nil
      remove_column :contents, :blog_id rescue nil
      raise e
    end
  end

  def self.down
    remove_index :contents, :blog_id
    remove_column :contents, :blog_id
  end
end
