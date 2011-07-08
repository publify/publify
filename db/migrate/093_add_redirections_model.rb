class AddRedirectionsModel < ActiveRecord::Migration
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
    create_table :redirections do |t|
      t.column :content_id, :integer
      t.column :redirect_id, :integer
    end

    say_with_time "Creating shortened URL for existing contents, this may take a moment" do
      Content.already_published.each do |art|

        # Begin / rescue statement is mandatory here because I have something
        # fishy in my database coming from a very old Wordpress import
        # This can happen you too
        begin
          say "Processing #{art.type} #{art.id}", true
          red = Redirect.new
          red.from_path = red.shorten
          red.to_path = art.permalink_url
          art.redirects << red
          art.save
        rescue
          nil
        end
      end
    end
  end

  def self.down
    Content.already_published.each do |art|
      art.redirects.each do |red|
        red.destroy
      end
    end

    drop_table :redirections
  end
end

