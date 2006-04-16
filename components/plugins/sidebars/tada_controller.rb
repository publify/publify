class Plugins::Sidebars::TadaController < Sidebars::ComponentPlugin
  display_name "Tada List"
  description 'To-do list from <a href="http://www.tadalist.com">tadalist.com</a>'

  setting :feed,  '', :label => 'Feed URL'
  setting :count, 10, :label => 'Items limit'

  def content
    response.lifetime = 1.day
    @tada=check_cache(Tada, @sb_config['feed']) rescue nil
  end
end
