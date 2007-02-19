class TadaSidebar < Sidebar
  display_name "Tada List"
  description 'To-do list from <a href="http://www.tadalist.com">tadalist.com</a>'

  setting :feed,  '', :label => 'Feed URL'
  setting :count, 10, :label => 'Items limit'

  lifetime 1.day

  def tada
    @tada ||= Tada.new(feed)
  rescue Exception => e
    logger.info(e)
    nil
  end
end
