# coding: utf-8
class Admin::DashboardController < Admin::BaseController
  require 'open-uri'
  require 'time'
  require 'rexml/document'

  def index
    t = Time.new
    today = t.strftime('%Y-%m-%d 00:00')

    # Since last venue
    @newposts_count = Article.published_since(current_user.last_sign_in_at).count
    @newcomments_count = Feedback.published_since(current_user.last_sign_in_at).count

    # Today
    @statposts = Article.published.where('published_at > ?', today).count
    @statsdrafts = Article.drafts.where('created_at > ?', today).count
    @statspages = Page.where('published_at > ?', today).count
    @statuses = Note.where('published_at > ?', today).count
    @statuserposts = Article.published.where('published_at > ?', today).where(user_id: current_user.id).count
    @statcomments = Comment.where('created_at > ?', today).count
    @presumedspam = Comment.presumed_spam.where('created_at > ?', today).count
    @confirmed = Comment.ham.where('created_at > ?', today).count
    @unconfirmed = Comment.unconfirmed.where('created_at > ?', today).count

    @comments = Comment.last_published
    @drafts = Article.drafts.where('user_id = ?', current_user.id).limit(5)

    @statspam = Comment.spam.count
    @inbound_links = inbound_links
    @publify_links = publify_dev
    publify_version
  end

  def publify_version
    version = nil
    begin
      open(PUBLIFY_VERSION_URL) do |http|
        publify_version = http.read[0..5]
        version = publify_version.split('.')
      end
    rescue
      return
    end
    if version[0].to_i > TYPO_MAJOR.to_i
      flash[:error] = I18n.t('admin.dashboard.publify_version.error')
    elsif version[1].to_i > TYPO_SUB.to_i
      flash[:warning] = I18n.t('admin.dashboard.publify_version.warning')
    elsif version[2].to_i > TYPO_MINOR.to_i
      flash[:notice] = I18n.t('admin.dashboard.publify_version.notice')
    end
  end

  private

  def inbound_links
    host = URI.parse(this_blog.base_url).host
    return [] if Rails.env.development?
    url = "http://www.google.com/search?q=link:#{host}&tbm=blg&output=rss"
    fetch_rss(url).reverse.compact
  end

  def publify_dev
    url = 'http://blog.publify.co/articles.rss'
    fetch_rss(url)[0..2]
  end

  def fetch_rss(url)
    open(url) do |http|
      return parse_rss(http.read)
    end
  rescue
    []
  end

  RssItem = Struct.new(:link, :title, :description, :description_link, :date, :author) do
    def to_s
      title
    end
  end

  def parse_rss(body)
    doc = Feedjira::Feed.parse(body)
    doc.entries
  end
end
