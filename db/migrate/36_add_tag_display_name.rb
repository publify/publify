class AddTagDisplayName < ActiveRecord::Migration
  def self.up
    STDERR.puts 'Adding display name to tags'
    Tag.transaction do
      add_column :tags, :display_name, :string

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
            origtag = Tag.find(:first, :conditions => [%{name = ? AND id != ?}, tag.name, tag.id])
            unless origtag.nil?
              # yep, duplicate tag
              tag.articles.each do |article|
                # replace our tag with origtag in article.tags
                article.tags = article.tags.collect { |x| x.id == tag.id ? origtag : x }
              end
              tag.destroy
            else
              # ok, original tag
              tag.save
            end
          else
            tag.save
          end
        end
      end
    end
  end

  def self.down
    STDERR.puts 'Removing display name from tags'
    Tag.transaction do
      unless $schema_generator
        Tag.find(:all).each do |tag|
          tag.name = tag.display_name
          tag.save
        end
      end

      remove_column :tags, :display_name
    end
  end
end
