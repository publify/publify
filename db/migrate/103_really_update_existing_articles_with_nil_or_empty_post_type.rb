class ReallyUpdateExistingArticlesWithNilOrEmptyPostType < ActiveRecord::Migration
  class Content < ActiveRecord::Base
    inheritance_column = :ignore_inheritance_column
  end

  def self.up
    say_with_time "Really fix existing articles with no post type." do
      Content.find(:all,
                   :conditions => ['type = ?', 'Article']).each do |art|
        if art.post_type.nil? or art.post_type.empty?
          say "Fixing '#{art.title}'", 1
          art.post_type = "read"

          # this doesn't really belong here but since this migration
          # would otherwise reset tags, it's better than nothing.
          art.keywords = art.tags.collect(&:name).join(" ")

          art.save!
        end
      end
    end
  end

  def self.down
    say "This rollback does nothing, but that's okay."
  end
end
