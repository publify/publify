class Plugins::Sidebars::MagnoliaController < Sidebars::ComponentPlugin
  description 'Pictures from <a href="http://ma.gnolia.com">ma.gnolia.com</a>'

  setting :dtitle, 'Ma.gnolia Links', :label => 'Display Title'
  setting :feed,   'http://ma.gnolia.com/rss/full/people/USERNAME/', :label => 'Feed URL'
  setting :count,   5, :label => 'Items limit'

  def content
    begin
      response.lifetime = 1.hour
      @mag=check_cache(MagnoliaAggregation, @sb_config['feed'])
    rescue Exception => e
      logger.info e
      ""
    end
  end
end
