class SuperclassTrackbacks < ActiveRecord::Migration
  class BareContent < ActiveRecord::Base
    include BareMigration
    set_inheritance_column :bogustype     # see migration #20 for why
  end

  class BareTrackback < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    say "Merging Trackbacks into Content table"
    # Ensure that the index we're going to remove in the transaction
    # is actually there (otherwise Postgres breaks)
    # Comment because already in migration 001
    #add_index(:trackbacks, :article_id) rescue nil
    modify_tables_and_update([:add_column,   BareContent,   :blog_name, :string],
                             [:remove_index, BareTrackback, :article_id        ]) do
      BareContent.transaction do
        if not $schema_generator
          BareTrackback.find(:all).each do |tb|
            a = BareContent.find(tb.article_id)
            BareContent.create(:type       => 'Trackback',
                               :article_id => tb.article_id,
                               :blog_name  => tb.blog_name,
                               :title      => tb.title,
                               :excerpt    => tb.excerpt,
                               :url        => tb.url,
                               :ip         => tb.ip,
                               :created_at => tb.created_at,
                               :updated_at => tb.updated_at,
                               :guid       => tb.guid)
          end
        end
      end
    end
    drop_table :trackbacks
  end

  def self.transactions_init(t)
    t.column :article_id, :integer
    t.column :blog_name, :string
    t.column :title, :string
    t.column :excerpt, :string
    t.column :url, :string
    t.column :ip, :string
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
    t.column :guid, :string
  end

  def self.down
    say "Recreating Trackbacks from Contents table"
    modify_tables_and_update([:create_table, :trackbacks, lambda {|t| transactions_init(t)}],
                             [:add_index,    :trackbacks, :article_id]) do
      BareContent.transaction do
        BareContent.find(:all, :conditions => ["type = ?", 'Trackback']).each do |tb|
          BareTrackback.create(:article_id => tb.article_id,
                               :blog_name  => tb.blog_name,
                               :title      => tb.title,
                               :excerpt    => tb.excerpt,
                               :url        => tb.url,
                               :ip         => tb.ip,
                               :created_at => tb.created_at,
                               :updated_at => tb.updated_at,
                               :guid       => tb.guid)
        end
        BareContent.delete_all("type = 'Trackback'")
      end
    end
    remove_column :contents, :blog_name
  end
end
