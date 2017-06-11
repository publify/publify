# This migration comes from publify_core_engine (originally 20150807134129)
class SimplifyRedirectRelations < ActiveRecord::Migration[4.2]
  class Redirect < ActiveRecord::Base; end
  class Redirection < ActiveRecord::Base; end

  def up
    add_column :redirects, :content_id, :integer
    Redirect.find_each do |redirect|
      redirections = Redirection.where(redirect_id: redirect.id)
      if redirections.count > 1
        raise "Expected zero or one redirections, found #{redirections.count}"
      end
      redirection = redirections.first
      next unless redirection
      redirect.content_id = redirection.content_id
      redirect.save!
    end
    remove_column :redirects, :origin
    drop_table :redirections
  end

  def down
    create_table :redirections do |t|
      t.integer :content_id
      t.integer :redirect_id
    end

    add_index :redirections, [:content_id]
    add_index :redirections, [:redirect_id]

    add_column :redirects, :origin, :string

    Redirect.find_each do |redirect|
      next unless redirect.content_id
      Redirection.create(redirect_id: redirect.id, content_id: redirect.content_id)
    end
    remove_column :redirects, :content_id
  end
end
