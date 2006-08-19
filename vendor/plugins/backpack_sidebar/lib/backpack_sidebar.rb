class BackpackSidebar < Sidebar

  description 'Lists from <a href="http://www.backpackit.com">backpackit.com</a>'

  setting :username
  setting :token
  setting :page_id, 0, :label => 'Page ID'
  setting :count,   0, :label => 'Items limit'

  lifetime 1.day

  attr_reader :backback
  attr_reader :items

  def content
    @backpack = Backpack.new(username, token, page_id) rescue nil
    @items = @backpack.items rescue []
    @items = @items.slice(0, count.to_i) if count.to_i > 0
  end
end
