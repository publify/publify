# BareMigration doesn't handle inheritance yet.  Therefore, we need
# to mimic it manually using conditions on find().  Since this script
# doesn't need to set type or id, there's no need to move either of
# the protected fields out of the way like we do in #20-23.

# BareMigration ALSO doesn't handle associations... yet.
# For now, that means your keywords won't be automatically converted
# to tags.  That might not be a bad thing...


class Bare24Article < ActiveRecord::Base
  include BareMigration
  include TypoGuid

  set_table_name :contents
  has_and_belongs_to_many :tags,
      :class_name => 'Bare24Tag', :foreign_key => 'article_id',
      :join_table => 'articles_tags', :association_foreign_key => 'tag_id'
end

class Bare24Tag < ActiveRecord::Base
  include BareMigration
  has_and_belongs_to_many :articles,
      :class_name => 'Bare24Article', :foreign_key => 'tag_id',
      :join_table => 'articles_tags', :association_foreign_key => 'articles_id'
end

class CleanupContents < ActiveRecord::Migration
  def self.up
    say "Updating all articles"
    # This is needed when migrating from 2.5.x, because we skip GUID
    # generation and tagging during earlier migrations.
    Bare24Article.transaction do
      Bare24Article.find(:all, :conditions => "type = 'Article'").each do |a|
        a.create_guid
        a.save!
      end
    end
  end

  def self.down
    # nothing
  end
end
