class AddOriginToRedirects < ActiveRecord::Migration
  def self.up
    add_column :redirects, :origin, :string

    say "Adding origin to redirects made by URL shortener"
    Content.find_already_published.each do |art|

      # Begin / rescue statement is mandatory here because I have something
      # fishy in my database coming from a very old Wordpress import
      # This can happen you too
      begin
        say "Processing #{art.type} #{art.id}", true
        art.redirects.each do |r|
          r.origin = "shortener"
          r.save!
        end
      rescue
        nil
      end
    end
  end

  def self.down
    remove_column :redirects, :origin
  end
end

