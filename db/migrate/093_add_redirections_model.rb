class AddRedirectionsModel < ActiveRecord::Migration
  def self.up
    create_table :redirections do |t|
      t.column :content_id, :integer
      t.column :redirect_id, :integer
    end

    puts "Creating shortened URL for existing contents, this may take a moment"
    Content.find_already_published.each do |art|

      # Begin / rescue statement is mandatory here because I have something
      # fishy in my database coming from a very old Wordpress import
      # This can happen you too
      begin
        puts "Processing #{art.type} #{art.id}"
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

  def self.down
    Content.find_already_published.each do |art|
      content.redirects.each do |red|
        red.destroy
      end
    end

    drop_table :redirections
  end
end

