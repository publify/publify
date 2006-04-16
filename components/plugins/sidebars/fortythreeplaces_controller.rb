class Plugins::Sidebars::FortythreeplacesController < Sidebars::ComponentPlugin
  display_name "43places"
  description 'List of your <a href="http://www.43places.com/">43places.com</a>.'

  setting :feed, 'http://www.43places.com/rss/uber/author?username=USER', :label => 'Feed URL'
  setting :count, 43, :label => 'Items limit'

  def content
    response.lifetime = 1.day
    @fortythreeplaces=check_cache(Fortythree, @sb_config['feed']) rescue nil
  end
end
