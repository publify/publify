class Admin::DashboardController < Admin::BaseController
  require 'open-uri'
  require 'time'
  require 'rexml/document'
  
  def index
    comments
    lastposts
    popular
    statistics
    inbound_links
    typo_dev
  end
  
  private
  
  def statistics
    @statposts = Article.count_published_articles
    @statuserposts = current_user.articles.size
    @statcomments = Comment.count(:all, :conditions => "state != 'spam'")
    @statspam = Comment.count(:all, :conditions => { :state => 'spam' })
  end
  
  def comments
    @comments ||=
      Comment.find(:all,
                   :limit => 5,
                   :conditions => ['published = ?', true],
                   :order => 'created_at DESC')
  end
  
  def lastposts
    @recent_posts = Article.find(:all, 
                                 :conditions => ["published = ?", true], 
                                 :order => 'published_at DESC', 
                                 :limit => 5)
  end
  
  def popular
    @bestof = Article.find(:all,
                           :select => 'contents.*, comment_counts.count AS comment_count',
                           :from => "contents, (SELECT feedback.article_id AS article_id, COUNT(feedback.id) as count FROM feedback WHERE feedback.state IN ('presumed_ham', 'ham') GROUP BY feedback.article_id ORDER BY count DESC LIMIT 9) AS comment_counts",
                           :conditions => ['comment_counts.article_id = contents.id AND published = ?', true],
                           :order => 'comment_counts.count DESC',
                           :limit => 5) 
  end
  
  def inbound_links
    url = "http://blogsearch.google.com/blogsearch_feeds?q=link:#{this_blog.base_url}&num=5&output=rss"
    open(url) do |http|
      @inbound_links = parse_rss(http.read)
    end
  rescue
    @inbound_links = nil
  end
  
  def typo_dev
    url = "http://blog.typosphere.org/articles.rss"
    open(url) do |http|
      @typo_links = parse_rss(http.read)[0..1]
    end
  rescue
    @typo_links = nil
  end
  
  private
  
  class RssItem < Struct.new(:link, :title, :description, :description_link, :date, :author)
    def to_s; title end
  end
  
  def parse_rss(body)
    xml = REXML::Document.new(body)
 
    items        = []
    link         = REXML::XPath.match(xml, "//channel/link/text()").first.value rescue ""
    title        = REXML::XPath.match(xml, "//channel/title/text()").first.value rescue ""
 
    REXML::XPath.each(xml, "//item/") do |elem|
      item = RssItem.new
      item.title       = REXML::XPath.match(elem, "title/text()").first.value rescue ""
      item.link        = REXML::XPath.match(elem, "link/text()").first.value rescue ""
      item.description = REXML::XPath.match(elem, "description/text()").first.value rescue ""
      item.author = REXML::XPath.match(elem, "dc:publisher/text()").first.value rescue ""
      item.date        = Time.mktime(*ParseDate.parsedate(XPath.match(elem, "dc:date/text()").first.value)) rescue Time.now
 
      item.description_link = item.description
      item.description.gsub!(/<\/?a\b.*?>/, "") # remove all <a> tags
      items << item
    end
 
    items.sort_by { |item| item.date }
  end
end
