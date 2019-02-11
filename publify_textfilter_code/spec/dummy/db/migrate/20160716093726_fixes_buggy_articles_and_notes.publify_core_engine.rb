# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 114)
class FixesBuggyArticlesAndNotes < ActiveRecord::Migration[4.2]
  class Content < ActiveRecord::Base
  end

  class Article < Content
    def set_permalink
      return if state == 'draft' || permalink.present?
      self.permalink = title.to_permalink
    end
  end

  class Note < Content
    def set_permalink
      self.permalink = "#{id}-#{body.to_permalink[0..79]}" if permalink.blank?
      save
    end

    def create_guid
      return true unless guid.blank?

      self.guid = UUIDTools::UUID.random_create.to_s
    end
  end

  class Page < Content
    def set_permalink
      self.name = title.to_permalink if name.blank?
    end
  end

  def self.up
    say 'Fixing contents permalinks, this may take some time'

    contents = Content.where('permalink is ? or permalink = ?', nil, '')
    contents.each do |c|
      c.set_permalink
      c.save
    end

    say 'Fixes empty notes GUID'
    notes = Note.where('guid is ? or guid = ?', nil, '')
    notes.each do |n|
      n.create_guid
      n.save
    end
  end

  def self.down
    say 'Nothing to do here'
  end
end
