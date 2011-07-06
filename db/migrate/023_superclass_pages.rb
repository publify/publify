class Bare23Content < ActiveRecord::Base
  include BareMigration
  set_inheritance_column :bogustype     # see migration #20 for why
end

class Bare23Page < ActiveRecord::Base
  include BareMigration
end

class SuperclassPages < ActiveRecord::Migration
  def self.up
    say "Merging Pages into Content table"
    modify_tables_and_update(:add_column, Bare23Content, :name, :string) do
      Bare23Content.transaction do
        if not $schema_generator
          Bare23Page.find(:all).each do |p|
            Bare23Content.create(:type           => 'Page',
                                 :name           => p.name,
                                 :user_id        => p.user_id,
                                 :body           => p.body,
                                 :body_html      => p.body_html,
                                 :created_at     => p.created_at,
                                 :updated_at     => (p.modified_at rescue p.updated_at),
                                 :title          => p.title,
                                 :text_filter_id => p.text_filter_id)
          end
        end
      end
    end
    drop_table :pages
  end

  def self.init_pages(t)
    t.column :name, :string
    t.column :user_id, :integer
    t.column :body, :text
    t.column :body_html, :text
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
    t.column :title, :string
    t.column :text_filter_id, :integer
    t.column :whiteboard, :text
  end

  def self.down
    say "Recreating pages table"
    modify_tables_and_update(:create_table, :pages, lambda {|t| init_pages(t)}) do
      Bare23Content.transaction do
        Bare23Content.find(:all, :conditions => "type = 'Page'").each do |p|
          Bare23Page.create(:name           => p.name,
                            :user_id        => p.user_id,
                            :body           => p.body,
                            :body_html      => p.body_html,
                            :created_at     => p.created_at,
                            :updated_at     => p.updated_at,
                            :title          => p.title,
                            :text_filter_id => p.text_filter_id,
                            :whiteboard     => p.whiteboard)
        end
        Bare23Content.delete_all "type = 'Page'"
      end
    end
    remove_column :contents, :name
  end
end
