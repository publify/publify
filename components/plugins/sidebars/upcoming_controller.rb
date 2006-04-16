class Plugins::Sidebars::UpcomingController < Sidebars::ComponentPlugin
  description 'Events from <a href="http://www.upcoming.org">upcoming.org</a>'

  setting :feed, '', :label => 'Feed URL'
  setting :count, 4, :label => 'Items Limit'

  def content
    response.lifetime = 6.hours
    @upcoming=check_cache(Upcoming, @sb_config['feed']) rescue nil
  end
end
