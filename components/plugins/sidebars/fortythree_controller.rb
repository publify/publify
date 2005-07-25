class Plugins::Sidebars::FortythreeController < Sidebars::Plugin
  def self.display_name
    "43things"
  end

  def self.description
    'Goals from <a href="http://www.43things.com/">43things.com</a>.'
  end

  def self.default_config
    {'feed'=>'http://www.43things.com/rss/uber/author?username=USER','count'=>43}
  end

  def content
    @fortythree=check_cache(Fortythree, @sb_config['feed']) rescue nil
  end

  def configure
  end
end
