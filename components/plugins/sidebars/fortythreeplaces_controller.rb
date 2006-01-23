class Plugins::Sidebars::FortythreeplacesController < Sidebars::Plugin
  def self.display_name
    "43places"
  end

  def self.description
    'List of your <a href="http://www.43places.com/">43places.com</a>.'
  end

  def self.default_config
    {'feed'=>'http://www.43places.com/rss/uber/author?username=USER','count'=>43}
  end

  def content
    response.lifetime = 1.day
    @fortythreeplaces=check_cache(Fortythree, @sb_config['feed']) rescue nil
  end

  def configure
  end
end
