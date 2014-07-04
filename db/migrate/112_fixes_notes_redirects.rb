class FixesNotesRedirects < ActiveRecord::Migration  
  def self.up
    say "Fixes notes redirects, it may take some time"

    Note.find_each do |note|
      if note.redirects.size > 0
        old_from = note.redirects.first.to_path
        from = note.redirects.first.from_path
        to = note.redirects.first.to_path.gsub(File.join(Blog.default.base_url, "st"), File.join(Blog.default.base_url, "note"))
        redirect = note.redirects.first
        redirect.update_attribute('to_path', to)
        redirect.save!
        Redirect.create(from_path: old_from, to_path: to)
      end
    end
  end

  def self.down
    say "Fixes statuses redirects"

    Notes.find_each do |note|
      if note.redirects.size > 0
        redirect = Redirect.find.where(to_path: note.redirects.first.to_path)
        redirect.destroy
        note.redirects.first.to_path = note.redirects.first.to_path.gsub!(File.join(Blog.default.base_url, "note"), File.join(Blog.default.base_url, "st"))
        note.redirects.first.save
      end
    end
  end
end
