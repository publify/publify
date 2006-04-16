class Plugins::Sidebars::FortythreeController < Sidebars::ComponentPlugin
  display_name "43things"
  description 'Goals from <a href="http://www.43things.com/">43things.com</a>.'

  setting :feed, 'http://www.43things.com/rss/uber/author?username=USER', :label => 'Feed URL'
  setting :count, 43, :label => 'Items limit'

  def content
    response.lifetime = 1.day
    @fortythree=check_cache(Fortythree, @sb_config['feed']) rescue nil
  end
end
