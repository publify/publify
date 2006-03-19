class Plugins::Sidebars::MagnoliaController < Sidebars::Plugin
  def self.display_name
    "Magnolia"
  end

  def self.description
    'Pictures from <a href="http://ma.gnolia.com">ma.gnolia.com</a>'
  end

  def self.default_config
    {'count'=>5,'feed'=>'feed://ma.gnolia.com/rss/full/people/USERNAME/', 'dtitle'=>'Ma.gnolia Links'}
  end

  def content
    begin
      response.lifetime = 1.hour
      @mag=check_cache(MagnoliaAggregation, @sb_config['feed'])
    rescue Exception => e
      logger.info e
      ""
    end
  end

  def configure
  end
end
