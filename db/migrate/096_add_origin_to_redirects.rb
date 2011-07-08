class AddOriginToRedirects < ActiveRecord::Migration
  class Redirect < ActiveRecord::Base
    has_many :redirections
    has_many :contents, :through => :redirections
  end

  class Redirection < ActiveRecord::Base
    belongs_to :content
    belongs_to :redirect
  end

  class Content < ActiveRecord::Base
    has_many :redirections
    has_many :redirects, :through => :redirections
    scope :already_published, {
      :conditions => ['published = ? AND published_at < ?', true, Time.now] }

    # Avoid STI errors
    set_inheritance_column :bogustype
  end

  def self.up
    add_column :redirects, :origin, :string

    say "Adding origin to redirects made by URL shortener"
    Content.already_published.each do |art|

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

