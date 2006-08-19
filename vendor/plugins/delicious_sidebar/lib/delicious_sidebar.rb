class DeliciousSidebar < Sidebar
  display_name "Del.icio.us"
  description 'Bookmarks from <a href="http://del.icio.us">del.icio.us</a>'

  setting :feed, nil, :label => 'Feed URL'
  setting :count, 10, :label => 'Items Limit'
  setting :groupdate,   false, :input_type => :checkbox, :label => 'Group links by day'
  setting :description, false, :input_type => :checkbox, :label => 'Show description'
  setting :desclink,    false, :input_type => :checkbox, :label => 'Allow links in description'

  lifetime 1.hour

  def delicious
    @delicious ||= Delicious.new(feed) rescue nil
  end

  def parse_request(contents, params)
    return unless delicious

    if groupdate
      @delicious.days = {}
      @delicious.items.each_with_index do |d,i|
        break if i >= count.to_i
        index = d.date.strftime("%Y-%m-%d").to_sym
        (@delicious.days[index] ||= []) << d
      end
      @delicious.days =
        @delicious.days.sort_by { |d| d.to_s }.reverse.collect do |d|
        {:container => d.last, :date => d.first}
      end
    else
      @delicious.items = @delicious.items.slice(0, count.to_i)
    end
  end
end
