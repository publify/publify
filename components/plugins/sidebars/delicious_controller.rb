class Plugins::Sidebars::DeliciousController < Sidebars::Plugin
  def self.display_name
    "Del.icio.us"
  end

  def self.description
    'Bookmarks from <a href="http://del.icio.us">del.icio.us</a>'
  end

  def self.default_config
    {'feed'=>'http://del.icio.us/rss/USERNAME','count'=>10}
  end

  def content
    @delicious=check_cache(Delicious, @sb_config['feed']) rescue nil
  end

  def configure
  end
end
