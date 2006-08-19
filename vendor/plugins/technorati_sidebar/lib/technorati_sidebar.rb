class TechnoratiSidebar < Sidebar
  description 'Display a <a href="http://www.technorati.com">Technorati</a> Watchlist'

  setting :name, 'Watchlist'
  setting :feed, 'http://www.technorati.com/watchlists/rss.html?wid=WATCHLISTID', :label => 'Feed URL'
  setting :count, 4, :label => 'Items limit'

  lifetime 1.hour

  def cosmos
    @cosmos ||= Technorati.new(feed)
  rescue Exception => e
    logger.info e
    nil
  end
end
