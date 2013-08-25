class FixesNotesRedirects < ActiveRecord::Migration  
  def self.up
    say "Fixes notes redirects"

    notes = Note.find(:all)
    notes.each do |note|
      if note.redirects.size > 0
        say "Fixes note #{note.id}"
        from = note.redirects.first.to_path
        note.redirects.first.to_path.gsub!(File.join(Blog.default.base_url, "st"), File.join(Blog.default.base_url, "note"))
        note.redirects.first.save
        redirect = Redirect.new(from_path: from, to_path: note.redirects.first.to_path)
        redirect.save
      end
    end
  end

  def self.down
    say "Fixes statuses redirects"

    notes = Note.find(:all)
    notes.each do |note|
      if note.redirects.size > 0
        redirect = Redirect.find.where(to_path: note.redirects.first.to_path)
        redirect.destroy
        note.redirects.first.to_path.gsub!(File.join(Blog.default.base_url, "note"), File.join(Blog.default.base_url, "st"))
        note.redirects.first.save
      end
    end
  end
end
