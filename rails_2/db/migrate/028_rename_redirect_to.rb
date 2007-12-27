class RenameRedirectTo < ActiveRecord::Migration
  def self.up
    # The original version of the redirects table used 'to' as a column name
    # Postgres is okay with that, but not mysql.
    rename_column :redirects, :to, :to_path rescue nil
  end

  def self.down
    # don't rename column back to broken name.
    # there's little chance this column will be used before now anyway.
  end
end
