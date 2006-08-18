class FixCanonicalServerUrl < ActiveRecord::Migration
  def self.up
    unless $schema_generator
      b = Blog.find(1)
      b.canonical_server_url = b.canonical_server_url.gsub(%r{/$},'')
      b.save
    end
  end

  def self.down
  end
end
