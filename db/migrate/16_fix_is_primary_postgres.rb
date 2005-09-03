# The PostgreSQL schema for 2.0.6 differs from the MySQL schema--
# pgsql had articles_categories.primary_item, while mysql had 
# articles_categories.is_primary.  More modenen schemas all have is_primary.
# This will break Postgres upgrades from 2.0.6, and apparently it bit #375.

class FixIsPrimaryPostgres < ActiveRecord::Migration
  def self.up
    config = ActiveRecord::Base.configurations
    if not $schema_generator and config[RAILS_ENV]['adapter'] == 'postgres'
      execute "alter table articles_categories rename primary_item to is_primary" rescue nil
    end
  end

  def self.down
    # don't do anything
    # this is a one-way migration, but it's not "irreversable"
    # because it doesn't change any code logic
  end
end
