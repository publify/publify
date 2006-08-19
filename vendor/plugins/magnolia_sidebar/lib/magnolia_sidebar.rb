class MagnoliaSidebar < Sidebar
  description 'Pictures from <a href="http://ma.gnolia.com">ma.gnolia.com</a>'

  setting :dtitle, 'Ma.gnolia Links', :label => 'Display Title'
  setting :feed,   'http://ma.gnolia.com/rss/full/people/USERNAME/', :label => 'Feed URL'
  setting :count,   5, :label => 'Items limit'

  lifetime 1.hour

  def mag
    @mag ||= MagnoliaAggregation.new(feed)
  rescue Exception => e
    logger.info e
    nil
  end
end
