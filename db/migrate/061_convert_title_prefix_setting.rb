class ConvertTitlePrefixSetting < ActiveRecord::Migration
  class BareBlog < ActiveRecord::Base
    include BareMigration

    serialize :settings, Hash
  end

  def self.up
    BareBlog.find(:all).each do |b|
      if b.settings.has_key? "title_prefix"
        b.settings["title_prefix"] = (b.settings["title_prefix"] ? 1 : 0)
        b.save!
      end
    end
  end

  def self.down
    BareBlog.find(:all).each do |b|
      if b.settings.has_key? "title_prefix"
        b.settings["title_prefix"] = (b.settings["title_prefix"] == 1)
        b.save!
      end
    end
  end
end
