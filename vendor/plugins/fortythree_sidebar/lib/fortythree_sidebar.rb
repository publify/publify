class FortythreeSidebar < Sidebar
  display_name "43things"
  description 'Goals from <a href="http://www.43things.com/">43things.com</a>.'

  setting :feed, 'http://www.43things.com/rss/uber/author?username=USER', :label => 'Feed URL'
  setting :count, 43, :label => 'Items limit'

  lifetime 1.day

  def fortythree
    @fortythree ||= Fortythree.new(feed) rescue nil
  end
end
