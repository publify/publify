class FixCanonicalServerUrl < ActiveRecord::Migration
  class Blog < ActiveRecord::Base
    include BareMigration
    serialize :settings, Hash
  end
  def self.up
    unless $schema_generator
      b = Blog.find(1)
      b.settings['canonical_server_url'] = b.settings['canonical_server_url'].gsub(%r{/$},'')
      b.save
    end
  end

  def self.down
  end
end
