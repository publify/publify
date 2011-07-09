class ConvertMysqlToInnodb < ActiveRecord::Migration
  def self.up
    config = ActiveRecord::Base.configurations
    begin
      say "Migrating all existing tables to InnoDB"
      schema = []
      select_all('SHOW TABLES').map do |table|
        "ALTER TABLE #{table.to_a.first.last} ENGINE=InnoDB"
      end
      schema.each { |line| execute line }
    end if config[::Rails.env]['adapter'] == 'mysql' unless $schema_generator
  end

  def self.down
    # don't do anything
    # this is a one-way migration, but it's not "irreversable"
    # because it doesn't change any code logic
  end
end
