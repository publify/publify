class Plugins::Sidebars::TadaController < Sidebars::Plugin
  def self.display_name
    "Tada List"
  end

  def self.description
    'To-do list from <a href="http://www.tadalist.com">tadalist.com</a>'
  end

  def self.default_config
    {'count'=>10}
  end

  def content
    @tada=check_cache(Tada, @sb_config['feed']) rescue nil
  end

  def configure
  end
end
