class AttachContentToBlog < ActiveRecord::Migration
  class BareContent < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    begin
      add_column :contents, :blog_id, :integer
      BareContent.find(:all).each {|c| c.blog_id = 1 }
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
