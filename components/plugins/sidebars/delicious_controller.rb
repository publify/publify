class Plugins::Sidebars::DeliciousController < Sidebars::ComponentPlugin
  display_name "Del.icio.us"
  description 'Bookmarks from <a href="http://del.icio.us">del.icio.us</a>'

  setting :feed, nil, :label => 'Feed URL'
  setting :count, 10, :label => 'Items Limit'
  setting :groupdate,   false, :input_type => :checkbox, :label => 'Group links by day'
  setting :description, false, :input_type => :checkbox, :label => 'Show description'
  setting :desclink,    false, :input_type => :checkbox, :label => 'Allow links in description'

  def content
    response.lifetime = 1.hour
    @delicious = check_cache(Delicious, @sb_config['feed']) rescue nil

    return unless @delicious

    if @sb_config['groupdate']
      @delicious.days = {}
      @delicious.items.each_with_index do |d,i|
        break if i >= @sb_config['count'].to_i
        index = d.date.strftime("%Y-%m-%d").to_sym
        (@delicious.days[index] ||= Array.new) << d
      end
      @delicious.days = @delicious.days.sort_by { |d| d.to_s }.reverse.collect { |d| {:container => d.last, :date => d.first} }
    else
      @delicious.items = @delicious.items.slice(0, @sb_config['count'].to_i)
    end
  end
end
