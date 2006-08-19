class UpcomingSidebar < Sidebar
  description 'Events from <a href="http://www.upcoming.org">upcoming.org</a>'

  setting :feed, '', :label => 'Feed URL'
  setting :count, 4, :label => 'Items Limit'

  lifetime 6.hours

  def upcoming
    @upcoming ||= Upcoming.new(feed)
  rescue Exception => e
    logger.info e
    nil
  end
end
