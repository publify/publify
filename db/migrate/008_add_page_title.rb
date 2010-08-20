class Bare8Page < ActiveRecord::Base
  include BareMigration
end

class AddPageTitle < ActiveRecord::Migration
  def self.up
    add_column :pages, :title, :string

    Bare8Page.create(:name=>"about",
      :title=>"about",
      :user_id=>1,
      :body=>"This is an example of a Typo page. You can edit this to write information about yourself or your site so readers know who you are. You can create as many pages as this one as you like and manage all of your content inside Typo."
      )

  end

  def self.down
    remove_column :pages, :title
  end
end
