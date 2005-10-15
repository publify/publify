class CleanupContents < ActiveRecord::Migration
  def self.up
    STDERR.puts "Updating all articles"
    # This is needed when migrating from 2.5.x, because we skip GUID
    # generation and tagging during earlier migrations.
    Article.find(:all).each do |a|
      a.save
    end
  end
end
