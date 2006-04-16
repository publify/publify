class Plugins::Sidebars::BackpackController < Sidebars::ComponentPlugin

  description 'Lists from <a href="http://www.backpackit.com">backpackit.com</a>'

  setting :username
  setting :token
  setting :page_id, 0, :label => 'Page ID'
  setting :count,   0, :label => 'Items limit'


  def content
    response.lifetime = 1.day
    @backpack = check_cache(Backpack, username, token, page_id) rescue nil
    @items = @backpack.items rescue []
    @items = @items.slice(0, count.to_i) if count.to_i > 0
  end
end
