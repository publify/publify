class FixCanonicalServerUrl < ActiveRecord::Migration
  class Blog < ActiveRecord::Base
    include BareMigration
    serialize :settings, Hash
  end
  def self.up
    unless $schema_generator
      Blog.find(:all).each do |b|
        b.settings['canonical_server_url'] = b.settings['canonical_server_url'].to_s.gsub(%r{/$},'')
        b.save
      end
    end
  end

  def self.down
  end
end
