class AudioscrobblerSidebar < Sidebar
  description 'Bookmarks from <a href="http://www.audioscrobbler.com">Audioscrobbler</a>'
  setting :feed, 'http://ws.audioscrobbler.com/rdf/history/USERNAME'
  setting :count, 10, :label => 'Items limit'

  lifetime 1.day

  attr_reader :audioscrobbler

  def parse_request(contents, params)
    @audioscrobbler = (Audioscrobbler.new(feed) rescue nil)
  end
end
