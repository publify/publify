class FixesBuggyArticlesAndNotes < ActiveRecord::Migration
  def self.up
    say "Fixing contents permalinks, this may take some time"

    contents = Content.where("permalink is ? or permalink = ?", nil, '')
    contents.each do |c|
      c.set_permalink
      c.save
    end

    say "Fixes empty notes GUID"
    notes = Note.where("guid is ? or guid = ?", nil, '')
    notes.each do |n|
      n.create_guid
      n.save
    end
  end

  def self.down
    say "Nothing to do here"
  end
end
