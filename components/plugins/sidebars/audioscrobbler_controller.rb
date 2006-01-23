class Plugins::Sidebars::AudioscrobblerController < Sidebars::Plugin
  def self.display_name
    "Audioscrobbler"
  end

  def self.description
    'Bookmarks from <a href="http://www.audioscrobbler.com">Audioscrobbler</a>'
  end

  def self.default_config
    {'feed'=>'http://ws.audioscrobbler.com/rdf/history/USERNAME','count'=>10}
  end

  def content
    response.lifetime = 1.day
    @audioscrobbler=check_cache(Audioscrobbler, @sb_config['feed']) rescue nil
  end

  def configure
  end
end
