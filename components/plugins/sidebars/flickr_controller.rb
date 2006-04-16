class Plugins::Sidebars::FlickrController < Sidebars::ComponentPlugin
  description 'Pictures from <a href="http://www.flickr.com">flickr.com</a>'
  setting :feed_url, nil
  setting :count,    4
  setting :format,  'rectangle', :choices => %w{rectangle square}

  def content
    begin
      response.lifetime = 1.hour
      @flickr=check_cache(FlickrAggregation, @sb_config['feed_url'])
    rescue Exception => e
      logger.info e
      nil
    end
  end
end
