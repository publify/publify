class Plugins::Sidebars::AudioscrobblerController < Sidebars::ComponentPlugin
  description 'Bookmarks from <a href="http://www.audioscrobbler.com">Audioscrobbler</a>'
  setting :feed, 'http://ws.audioscrobbler.com/rdf/history/USERNAME'
  setting :count, 10, :label => 'Items limit'

  def content
    response.lifetime = 1.day
    @audioscrobbler=check_cache(Audioscrobbler, @sb_config['feed']) rescue nil
  end
end
