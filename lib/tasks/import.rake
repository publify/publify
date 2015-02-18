namespace:import do
  desc 'Import from RSS'
  task :rss, [:url] => [:environment] do |t, args|
    require 'net/http'
    require 'rss/2.0'
    
    url, user_login = args[:url], args[:user_login]
    feed = Net::HTTP.get(URI.parse(url))
    rss = RSS::Parser.parse(feed)

    puts "Converting #{rss.items.length} entries..."
    rss.items.each do |item|
      puts "Converting '#{item.title}'"
      a = Article.new
      a.author = User.where(name: user_login).first
      a.title = item.title
      a.body = item.description
      a.created_at = item.pubDate
      a.save
    end

  end
end
