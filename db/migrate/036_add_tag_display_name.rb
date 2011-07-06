class AddTagDisplayName < ActiveRecord::Migration
  class Tag < ActiveRecord::Base
    has_and_belongs_to_many :articles
  end

  class Content < ActiveRecord::Base
  end

  class Article < Content
    has_and_belongs_to_many :tags
  end

  def self.up
    say 'Adding display name to tags'
    modify_tables_and_update(:add_column, Tag, :display_name, :string) do
      unless $schema_generator
        Tag.find(:all).each do |tag|
          tag.display_name = tag.name
          tag.name = tag.name.tr(' ', '').downcase
          if tag.name != tag.display_name
            # we need to make sure we're not attempting to create duplicate-named tags
            # if so, we need to coalesce them
            # Hopefully this code isn't necessary, but somebody may have tags "Monty Python" and "montypython"
            # Please note that this code isn't going to be tested very well, if at all, because of my limited
            # testing setup. But in my quickie tests it appears to be working right
            if origtag = Tag.find(:first, :conditions => [%{name = ? AND id != ?}, tag.name, tag.id])
              tag.articles.each do |article|
                # replace our tag with origtag in article.tags
                article.tags = article.tags.collect { |x| x.id == tag.id ? origtag : x }
              end
              tag.destroy
            else
              # ok, original tag
              tag.save!
            end
          else
            tag.save!
          end
        end
      end
    end
  end

  def self.down
    say 'Removing display name from tags'
    unless $schema_generator
      Tag.update_all('name = display_name')
    end
    remove_column :tags, :display_name
  end
end
