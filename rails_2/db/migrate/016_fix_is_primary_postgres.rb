# The PostgreSQL schema for 2.0.6 differs from the MySQL schema--
# pgsql had articles_categories.primary_item, while mysql had
# articles_categories.is_primary.  More modenen schemas all have is_primary.
# This will break Postgres upgrades from 2.0.6, and apparently it bit #375.

# Since we've removed the pointless articles_categories table from the migration
# we don't need to fix it up :)

class FixIsPrimaryPostgres < ActiveRecord::Migration
  def self.up

  end

  def self.down
  end
end
