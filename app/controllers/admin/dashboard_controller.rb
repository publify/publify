class Admin::DashboardController < Admin::BaseController
  require 'open-uri'
  require 'time'
  require 'rexml/document'

  def index
    @newposts_count = Article.published_since(current_user.last_venue).count
    @newcomments_count = Feedback.published_since(current_user.last_venue).count

    @statposts = Article.published.count
    @statcomments = Comment.not_spam.count
    @presumedspam = Comment.presumed_spam.count

    @categories = Category.count

    @comments = Comment.last_published
    @recent_posts = Article.published.limit(5)
    @bestof = Article.bestof
    @statuserposts = Article.published.count(conditions: {user_id: current_user.id})
    @statspam = Comment.spam.count
    @inbound_links = inbound_links
    @typo_links = typo_dev
    typo_version
  end

  def typo_version
    typo_version = nil
    version = TYPO_VERSION.to_s.split('.')
    begin
      url = "http://blog.typosphere.org/version.txt"
      open(url) do |http|
        typo_version = http.read[0..5]
        version = typo_version.split('.')
      end
    rescue
    end

    if version[0].to_i > TYPO_MAJOR.to_i
      flash.now[:error] = _("You are late from at least one major version of Typo. You should upgrade immediately. Download and install %s", "<a href='http://typosphere.org/stable.tgz'>#{_("the latest Typo version")}</a>").html_safe
    elsif version[1].to_i > TYPO_SUB.to_i
      flash.now[:warning] = _("There's a new version of Typo available which may contain important bug fixes. Why don't you upgrade to %s ?", "<a href='http://typosphere.org/stable.tgz'>#{_("the latest Typo version")}</a>").html_safe
    elsif version[2].to_i > TYPO_MINOR.to_i
      flash.now[:notice] = _("There's a new version of Typo available. Why don't you upgrade to %s ?", "<a href='http://typosphere.org/stable.tgz'>#{_("the latest Typo version")}</a>").html_safe
    end
  end

  private

  def inbound_links
    host = URI.parse(this_blog.base_url).host 
    return [] if (host.downcase == 'localhost' || host =~ /\.local$/) # don't try to fetch links for local blogs
    url = "http://www.google.com/search?q=link:#{this_blog.base_url}&tbm=blg&output=rss"
    parse(url).reverse.compact
  end

  def typo_dev
    url = "http://blog.typosphere.org/articles.rss"
    parse(url)[0..4]
  end


  def parse(url)
    open(url) do |http|
      return parse_rss(http.read)
    end
  rescue
    []
  end

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
      item.author      = REXML::XPath.match(elem, "dc:publisher/text()").first.value rescue ""
      item.date        = Time.mktime(*ParseDate.parsedate(REXML::XPath.match(elem, "dc:date/text()").first.value)) rescue Date.parse(REXML::XPath.match(elem, "pubDate/text()").first.value) rescue Time.now

      item.description_link = item.description
      item.description.gsub!(/<\/?a\b.*?>/, "") # remove all <a> tags
      items << item
    end

    items.sort_by { |item| item.date }
  end
end
