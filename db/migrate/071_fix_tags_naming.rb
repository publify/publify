class FixTagsNaming < ActiveRecord::Migration
  class Tag < ActiveRecord::Base
  end

  def self.up
    tags = Tag.find(:all)
    tags.each do |tag|
      tag.name = tag.name.gsub('.', '-')
      tag.save!
    end
  end

  def self.down
    tags = Tag.find(:all)
    tags.each do |tag|
      tag.name = tag.display_name.gsub('-', '.')
      tag.name = tag.name.gsub(' ', '').downcase
      tag.save!
    end
  end
end
