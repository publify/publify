require 'set'

class AddWhiteboardsToContent < ActiveRecord::Migration
  def self.up
    begin
      STDERR.print "Trying to add whiteboard to: articles..."
      add_column :articles, :whiteboard, :text
      STDERR.print " comments..."
      add_column :comments, :whiteboard, :text
      STDERR.print " pages..."
      add_column :pages, :whiteboard, :text
      STDERR.puts " done."
    rescue
      STDERR.puts "\nERROR unable to add whiteboard column"
    end
  end

  def self.down
    begin
      STDERR.print "Trying to drop whiteboard from: articles..."
      remove_column :comments, :whiteboard
      STDERR.print " comments..."
      remove_column :comments, :whiteboard
      STDERR.print " pages..."
      remove_column :pages, :whiteboard
      STDERR.puts " done."
    rescue
      STDERR.puts "\nERROR unable to remove whiteboard column"
    end
  end
end
