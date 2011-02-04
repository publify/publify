class Bare28Redirect < ActiveRecord::Base
  include BareMigration
end

class RenameRedirectTo < ActiveRecord::Migration
  def self.up
    # The original version of the redirects table used 'to' as a column name
    # Postgres is okay with that, but not mysql.
    # You need test if rename needed, because with migration transaction, all
    # failed if rename failed
    if Bare28Redirect.columns_hash.has_key? 'to'
      rename_column :redirects, :to, :to_path
    end
  end

  def self.down
    # don't rename column back to broken name.
    # there's little chance this column will be used before now anyway.
  end
end
