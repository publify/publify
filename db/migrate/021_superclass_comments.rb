class SuperclassComments < ActiveRecord::Migration
  class BareComment < ActiveRecord::Base
    include BareMigration
  end

  class BareContent < ActiveRecord::Base
    include BareMigration
    set_inheritance_column :bogustype     # see migration #20 for why
  end

  def self.up
    say "Merging Comments into Contents table"
    # Get our indices into a known good state.
    # Mutter dark imprecations at having to do this.
    #add_index(:comments, :article_id) rescue nil
    #remove_index(:contents, :article_id) rescue nil
    modify_tables_and_update([:add_column, BareContent, :article_id, :integer],
                             [:add_column, BareContent, :email,      :string ],
                             [:add_column, BareContent, :url,        :string ],
                             [:add_column, BareContent, :ip,         :string ],
                             [:add_index,  BareContent, :article_id          ]) do
      BareContent.transaction do
        if not $schema_generator
          BareComment.find(:all).each do |c|
            BareContent.create!(:type       => 'Comment',
                                :article_id => c.article_id,
                                :author     => c.author,
                                :email      => c.email,
                                :url        => c.url,
                                :ip         => c.ip,
                                :body       => c.body,
                                :body_html  => c.body_html,
                                :created_at => c.created_at,
                                :updated_at => c.updated_at,
                                :user_id    => c.user_id,
                                :guid       => c.guid,
                                :whiteboard => c.whiteboard)
          end
        end
      end
      remove_index(:comments, :article_id)
    end
    drop_table :comments
  end

  def self.init_comments_table(t)
    t.column :article_id, :integer
    t.column :title, :string
    t.column :author, :string
    t.column :email, :string
    t.column :url, :string
    t.column :ip, :string
    t.column :body, :text
    t.column :body_html, :text
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
    t.column :user_id, :integer
    t.column :guid, :string
    t.column :whiteboard, :text
  end


  def self.down
    say "Recreating Comments from Contents table"
    modify_tables_and_update([:create_table, BareComment, lambda {|t| self.init_comments_table(t)}],
                             [:add_index,    BareComment, :article_id           ]) do
      BareContent.transaction do
        BareComment.transaction do
          BareContent.find(:all, :conditions => "type = 'Comment'").each do |c|
            BareComment.create!(:article_id => c.article_id,
                                :title      => c.title,
                                :author     => c.author,
                                :email      => c.email,
                                :url        => c.url,
                                :ip         => c.ip,
                                :body       => c.body,
                                :body_html  => c.body_html,
                                :created_at => c.created_at,
                                :updated_at => c.updated_at,
                                :user_id    => c.user_id,
                                :guid       => c.guid,
                                :whiteboard => c.whiteboard)
          end
          BareContent.delete_all "type = 'Comment'"
        end
      end
      remove_index  :contents, :article_id
      remove_column :contents, :article_id
      remove_column :contents, :email
      remove_column :contents, :url
      remove_column :contents, :ip
    end
  end
end
