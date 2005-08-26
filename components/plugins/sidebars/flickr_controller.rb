class Plugins::Sidebars::FlickrController < Sidebars::Plugin
  def self.display_name
    "Flickr"
  end

  def self.description
    'Pictures from <a href="http://www.flickr.com">flickr.com</a>'
  end

  def self.default_config
    {'count'=>4,'format'=>'rectangle'}
  end

  def content
    @flickr=check_cache(FlickrAggregation, @sb_config['feed']) rescue nil
  end

  def configure
  end
end
