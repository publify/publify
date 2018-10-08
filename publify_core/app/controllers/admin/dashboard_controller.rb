# frozen_string_literal: true

require 'feedjira'

class Admin::DashboardController < Admin::BaseController
  require 'open-uri'
  require 'time'
  require 'rexml/document'

  def index
    today = Time.zone.now.strftime('%Y-%m-%d 00:00')

    # Since last visit
    last_sign_in = current_user.last_sign_in_at
    @newposts_count = Article.published_since(last_sign_in).count
    @newcomments_count = Feedback.created_since(last_sign_in).count

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
  end

  private

  def inbound_links
    host = URI.parse(this_blog.base_url).host
    return [] if Rails.env.development?

    url = "http://www.google.com/search?q=link:#{host}&tbm=blg&output=rss"
    fetch_rss(url).reverse.compact
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
