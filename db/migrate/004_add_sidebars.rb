class Bare4Sidebar < ActiveRecord::Base
  include BareMigration

  # there's technically no need for these serialize declaration because in
  # this script active_config and staged_config will always be NULL anyway.
  serialize :active_config
  serialize :staged_config
end

class AddSidebars < ActiveRecord::Migration
  def self.up
    say "Creating sidebars"
    Bare4Sidebar.transaction do
      create_table :sidebars do |t|
        t.column :controller, :string
        t.column :active_position, :integer
        t.column :active_config, :text
        t.column :staged_position, :integer
        t.column :staged_config, :text
      end

      Bare4Sidebar.create(:active_position=>0, :controller=>'page', :active_config=>'--- !map:HashWithIndifferentAccess
      maximum_pages: "10"')
      Bare4Sidebar.create(:active_position=>1, :controller=>'category', :active_config=>'--- !map:HashWithIndifferentAccess
      empty: false
      count: true')
      Bare4Sidebar.create(:active_position=>2, :controller=>'archives', :active_config=>'--- !map:HashWithIndifferentAccess
      show_count: true
      count: "10"')
      Bare4Sidebar.create(:active_position=>3, :controller=>'static', :active_config=>'--- !map:HashWithIndifferentAccess
      body: "<ul>\n  <li><a href=\"http://www.typosphere.org\" title=\"Typo\">Typosphere</a></li>\n  <li><a href=\"http://typogarden.org\">Typogarden</a></li>\n  <li><a href=\"http://t37.net\" title=\"Blog Exp\xC3\xA9rience utilisateur\">Fr\xC3\xA9d\xC3\xA9ric</a></li>\n  <li><a href=\"http://www.matijs.net/\" title=\"Matijs\">Matijs</a></li>\n<li><a href=\"http://elsif.fr\" title=\"Yannick\">Yannick</a></li>\n<li><a href=\"http://blog.ookook.fr\" title=\"Thomas\">Thomas</a></li>\n<li><a href=\"http://blog.shingara.fr\" title=\"Cyril\">Cyril</a></li>\n\n\
        </ul>\n"
      title: Links'
      )
      Bare4Sidebar.create(:active_position=>4, :controller=>'meta', :active_config=>'--- !map:HashWithIndifferentAccess
      title: Meta')
    end
  end

  def self.down
    drop_table :sidebars
  end
end


