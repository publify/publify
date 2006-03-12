class Plugins::Sidebars::BackpackController < Sidebars::Plugin
  def self.display_name
    "Backpack"
  end

  def self.description
    'Lists from <a href="http://www.backpackit.com">backpackit.com</a>'
  end

  def self.default_config
    {'username'=>'','token'=>'', 'page_id' => 0, 'count' => 0}
  end

  def content
    response.lifetime = 1.day
    @backpack = check_cache(Backpack, @sb_config['username'], @sb_config['token'], @sb_config['page_id']) rescue nil
    @items = @backpack.items rescue []
    @items = @items.slice(0,@sb_config['count'].to_i) if @sb_config['count'].to_i > 0
  end

  def configure
  end
end
