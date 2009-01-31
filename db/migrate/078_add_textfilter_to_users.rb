class AddTextfilterToUsers < ActiveRecord::Migration
  def self.up
    f = TextFilter.find(:first, :conditions => ["name = ?", "none"])
    add_column :users, :text_filter_id, :string, :default => f.id

    unless Blog.default.nil?
      t = TextFilter.find(:first, :conditions => "name= '#{Blog.default.text_filter}'")
      User.find(:all).each do |user|
        STDERR.puts "Adding textfilter #{t.name} to #{user.login}"
        user.text_filter_id = t.id
        user.save
      end
    end    
  end

  def self.down
    remove_column :text_filter_id, :integer
  end
end
