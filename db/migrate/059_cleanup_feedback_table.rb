class CleanupFeedbackTable < ActiveRecord::Migration
  def self.up
    remove_column :feedback, :extended
    remove_column :feedback, :keywords
    remove_column :feedback, :permalink
    remove_column :feedback, :allow_pings
    remove_column :feedback, :allow_comments
    remove_column :feedback, :name

    add_index :feedback, :article_id
    add_index :feedback, :text_filter_id
  end

  def self.down
    add_column :feedback, :extended,       :text
    add_column :feedback, :keywords,       :string
    add_column :feedback, :permalink,      :string
    add_column :feedback, :allow_pings,    :boolean
    add_column :feedback, :allow_comments, :boolean
    add_column :feedback, :name,           :string

    remove_index :feedback, :article_id
    remove_index :feedback, :text_filter_id
  end
end
