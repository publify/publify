class RenameRedirectTo < ActiveRecord::Migration
  def self.up
    # The original version of the redirects table used 'to' as a column name
    # Postgres is okay with that, but not mysql.
    rename_column :redirects, :to, :to_path rescue nil
  end

  def self.down
  end
end
