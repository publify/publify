class FlickrSidebar < Sidebar
  description 'Pictures from <a href="http://www.flickr.com">flickr.com</a>'
  setting :feed_url, nil
  setting :count,    4
  setting :format,  'rectangle', :choices => %w{rectangle square}

  lifetime 1.hour

  def flickr
    @flickr ||= FlickrAggregation.new(feed_url)
  rescue Exception => e
    logger.info e
    nil
  end
end
