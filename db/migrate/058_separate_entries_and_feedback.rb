class SeparateEntriesAndFeedback < ActiveRecord::Migration
  class Content < ActiveRecord::Base
  end

  class Feedback < ActiveRecord::Base
  end

  def self.up
    # Comment this out once you've made a backup
    raise "This is a more or less untested migration that might lose data. \nBackup before commenting out line 10 of db/migrate/058_separate_entries_and_feedback.rb"

    create_table :feedback, :force => true do |t|
      t.column "type",             :string
      t.column "title",            :string
      t.column "author",           :string
      t.column "body",             :text
      t.column "extended",         :text
      t.column "excerpt",          :text
      t.column "keywords",         :string
      t.column "created_at",       :datetime
      t.column "updated_at",       :datetime
      t.column "user_id",          :integer
      t.column "permalink",        :string
      t.column "guid",             :string
      t.column "text_filter_id",   :integer
      t.column "whiteboard",       :text
      t.column "article_id",       :integer
      t.column "email",            :string
      t.column "url",              :string
      t.column "ip",               :string,  :limit => 40
      t.column "blog_name",        :string
      t.column "name",             :string
      t.column "published",        :boolean, :default => false
      t.column "allow_pings",      :boolean
      t.column "allow_comments",   :boolean
      t.column "blog_id",          :integer, :null => false
      t.column "published_at",     :datetime
      t.column "state",            :text
      t.column "status_confirmed", :boolean
    end

    Content.transaction do
      Feedback.transaction do
        Content.find(:all, :conditions => {:type => %w{ Comment Trackback }}).each do |content|
          Feedback.new(content.attributes) do |fb|
            fb[:type] = content[:type]
            fb.save!
          end
        end
        Content.delete_all(:type => %w{ Comment Trackback })
      end
    end
  end

  def self.down
    Content.transaction do
      Feedback.transaction do
        Feedback.find(:all).each do |fb|
          Content.new(fb.attributes) do |cnt|
            cnt[:type] = fb[:type]
            cnt.save!
          end
        end
      end
    end

    drop_table :feedback
  end
end
