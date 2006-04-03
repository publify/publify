class Bare38Blog < ActiveRecord::Base
  include BareMigration
end

class Bare38Setting < ActiveRecord::Base
  include BareMigration
end

class AddBlogObject < ActiveRecord::Migration
  def self.up
    begin
      STDERR.puts "Adding a blogs table"
      create_table :blogs do |t|
        t.column :dummy, :string unless $schema_generator
      end
      unless $schema_generator
        Bare38Blog.reset_column_information

        add_column :settings, :blog_id, :integer
        Bare38Setting.reset_column_information

        Bare38Setting.transaction do
          STDERR.puts "Creating default blog"
          default_blog = Bare38Blog.create!

          STDERR.puts "Connecting settings to the default blog"

          STDERR.puts "New Default blog has id: " + default_blog.id.to_s
          STDERR.puts "Migrating #{Bare38Setting.find(:all).size} settings to the new Blog"

          Bare38Setting.find(:all).each do |setting|
            setting.blog_id = default_blog.id
            setting.save!
          end
        end
        remove_column :blogs, :dummy
      end
    rescue Exception => e
      STDERR.puts("Rolling back the changes")
      drop_table(:blogs) rescue nil
      remove_column(:settings, :blog_id) rescue nil
      raise e
    end
  end

  def self.down
    STDERR.puts "Unlinking settings and removing the blogs table"
    Bare38Setting.delete_all(["blog_id != ?", Bare38Blog.find(:first)])
    remove_column :settings, :blog_id
    drop_table :blogs
  end
end
