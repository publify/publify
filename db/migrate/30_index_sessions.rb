class IndexSessions < ActiveRecord::Migration
  def self.up
    add_index :sessions, :sessid rescue nil
  end

  def self.down
    remove_index :sessions, :sessid
  end
end
