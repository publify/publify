class CleanupContentsTable < ActiveRecord::Migration
  def self.up
    if adapter_name == 'PostgreSQL'
      indexes(:contents).each do |index|
        if index.name =~ /article_id/
          remove_index(:contents, :name => index.name)
        end
      end
    else
      remove_index :contents, :article_id rescue nil
    end

    remove_column :contents, :article_id rescue nil
    remove_column :contents, :email
    remove_column :contents, :url
    remove_column :contents, :ip
    remove_column :contents, :blog_name
    remove_column :contents, :status_confirmed

    add_index :contents, :published
    add_index :contents, :text_filter_id
  end

  def self.down
    remove_index :contents, :published
    remove_index :contents, :text_filter_id

    add_column :contents, :article_id, :integer
    add_column :contents, :email, :string
    add_column :contents, :url, :string
    add_column :contents, :ip, :string, :limit => 40
    add_column :contents, :blog_name, :string
    add_column :contents, :status_confirmed, :boolean

    add_index :contents, :article_id
  end
end
