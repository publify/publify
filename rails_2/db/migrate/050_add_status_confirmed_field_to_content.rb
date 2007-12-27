class AddStatusConfirmedFieldToContent < ActiveRecord::Migration
  class Content < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    modify_tables_and_update \
      [:add_column, Content, :status_confirmed, :boolean] do |a|
      if not $schema_generator
        a.status_confirmed = (a.state =~ /ContentState::(Sp|H)am/ ? true : false)
        a.save!
      end
    end
  end

  def self.down
    remove_column :contents, :status_confirmed
  end
end
