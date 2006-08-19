class Bare51Blog < ActiveRecord::Base
  include BareMigration
end

class FixCanonicalServerUrl < ActiveRecord::Migration
  def self.up
    unless $schema_generator
      b = Bare51Blog.find(1)
      b.settings[:canonical_server_url] = b.settings[:canonical_server_url].gsub(%r{/$},'')
      b.save
    end
  end

  def self.down
  end
end
