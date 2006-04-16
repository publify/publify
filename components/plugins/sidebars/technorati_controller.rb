class Plugins::Sidebars::TechnoratiController < Sidebars::ComponentPlugin
  description 'Display a <a href="http://www.technorati.com">Technorati</a> Watchlist'

  setting :name, 'Watchlist'
  setting :feed, 'http://www.technorati.com/watchlists/rss.html?wid=WATCHLISTID', :label => 'Feed URL'
  setting :count, 4, :label => 'Items limit'

  def content
    response.lifetime = 1.hour
    @cosmos = check_cache(Technorati, @sb_config['feed']) rescue nil
  end
end
