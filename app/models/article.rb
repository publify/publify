require 'uri'
require 'net/http'

class Article < Content
  include TypoGuid

  content_fields :body, :extended

  has_many :pings,      :dependent => :destroy, :order => "created_at ASC"
  has_many :comments,   :dependent => :destroy, :order => "created_at ASC"
  has_many :trackbacks, :dependent => :destroy, :order => "created_at ASC"
  has_many :resources, :order => "created_at DESC",
           :class_name => "Resource", :foreign_key => 'article_id'
  has_many :categorizations
  has_many :categories, :through => :categorizations, :uniq => true do
    def push_with_attributes(cat, join_attrs = { :is_primary => false })
      Categorization.with_scope(:create => join_attrs) { self << cat }
    end
  end
  has_and_belongs_to_many :tags, :foreign_key => 'article_id'
  belongs_to :user
  has_many :triggers, :as => :pending_item

  after_destroy :fix_resources

  def stripped_title
    self.title.gsub(/<[^>]*>/,'').to_url
  end

  def permalink_url(anchor=nil, only_path=true)
    @cached_permalink_url ||= {}
    @cached_permalink_url["#{anchor}#{only_path}"] ||= blog.url_for(
      :year => published_at.year,
      :month => sprintf("%.2d", published_at.month),
      :day => sprintf("%.2d", published_at.day),
      :title => permalink,
      :anchor => anchor,
      :only_path => only_path,
      :controller => '/articles'
    )
  end

  def trackback_url
    blog.url_for(:controller => "articles", :action =>"trackback", :id => id)
  end

  def feed_url(format = :rss20)
    blog.url_for(:controller => 'xml', :action => 'feed', :type => 'article', :format => format, :id => id)
  end

  def edit_url
    blog.url_for(:controller => "/admin/content", :action =>"edit", :id => id)
  end

  def delete_url
    blog.url_for(:controller => "/admin/content", :action =>"destroy", :id => id)
  end

  def html_urls
    urls = Array.new
    html.gsub(/<a [^>]*>/) do |tag|
      if(tag =~ /href="([^"]+)"/)
        urls.push($1)
      end
    end

    urls.uniq
  end

  def really_send_pings(serverurl = blog.base_url, articleurl = nil)
    return unless blog.send_outbound_pings

    articleurl ||= permalink_url(nil, false)

    weblogupdatesping_urls = blog.ping_urls.gsub(/ +/,'').split(/[\n\r]+/)
    pingback_or_trackback_urls = self.html_urls

    ping_urls = weblogupdatesping_urls + pingback_or_trackback_urls

    ping_urls.uniq.each do |url|
      begin
        unless pings.collect { |p| p.url }.include?(url.strip)
          ping = pings.build("url" => url)

          if weblogupdatesping_urls.include?(url)
            ping.send_weblogupdatesping(serverurl, articleurl)
          elsif pingback_or_trackback_urls.include?(url)
            ping.send_pingback_or_trackback(articleurl)
          end
        end
      rescue Exception => e
        logger.error(e)
        # in case the remote server doesn't respond or gives an error,
        # we should throw an xmlrpc error here.
      end
    end
  end

  def send_pings
    state.send_pings(self)
  end

  def next
    blog.articles.find(:first, :conditions => ['published_at > ?', published_at],
                       :order => 'published_at asc')
  end

  def previous
    blog.articles.find(:first, :conditions => ['published_at < ?', published_at],
                       :order => 'published_at desc')
  end

  # Count articles on a certain date
  def self.count_by_date(year, month = nil, day = nil, limit = nil)
    from, to = self.time_delta(year, month, day)
    Article.count(["published_at BETWEEN ? AND ? AND published = ?",
                   from, to, true])
  end

  # Find all articles on a certain date
  def self.find_all_by_date(year, month = nil, day = nil)
    from, to = self.time_delta(year, month, day)
    Article.find_published(:all, :conditions => ["published_at BETWEEN ? AND ?",
                                                 from, to])
  end

  # Find one article on a certain date

  def self.find_by_date(year, month, day)
    find_all_by_date(year, month, day).first
  end

  # Finds one article which was posted on a certain date and matches the supplied dashed-title
  def self.find_by_permalink(year, month, day, title)
    from, to = self.time_delta(year, month, day)
    find_published(:first,
                   :conditions => ['permalink = ? AND ' +
                                   'published_at BETWEEN ? AND ?',
                                   title, from, to ])
  end

  # Fulltext searches the body of published articles
  def self.search(query)
    if !query.to_s.strip.empty?
      tokens = query.split.collect {|c| "%#{c.downcase}%"}
      find_published(:all,
                     :conditions => [(["(LOWER(body) LIKE ? OR LOWER(extended) LIKE ? OR LOWER(title) LIKE ?)"] * tokens.size).join(" AND "), *tokens.collect { |token| [token] * 3 }.flatten])
    else
      []
    end
  end

  def keywords_to_tags
    Article.transaction do
      tags.clear
      keywords.to_s.scan(/((['"]).*?\2|[\.\w]+)/).collect do |x|
        x.first.tr("\"'", '')
      end.uniq.each do |tagword|
        tags << Tag.get(tagword)
      end
    end
  end

  def interested_users
    User.find_boolean(:all, :notify_on_new_articles)
  end

  def notify_user_via_email(user)
    if user.notify_via_email?
      EmailNotify.send_article(self, user)
    end
  end

  def notify_user_via_jabber(user)
    if user.notify_via_jabber?
      JabberNotify.send_message(user, "New post",
                                "A new message was posted to #{blog.blog_name}",
                                html(:body))
    end
  end

  def comments_closed?
    if self.allow_comments?
      if !self.blog.sp_article_auto_close.zero? and self.created_at.to_i < self.blog.sp_article_auto_close.days.ago.to_i
        return true
      else
        return false
      end
    else
      return true
    end
  end

  def published_comments
    comments.select {|c| c.published?}
  end

  def published_trackbacks
    trackbacks.select {|c| c.published?}
  end

  # Bloody rails reloading. Nasty workaround.
  def body=(newval)
    if self[:body] != newval
      changed
      self[:body] = newval
    end
    self[:body]
  end

  def body_html
    typo_deprecated "Use html(:body)"
    html(:body)
  end

  def extended=(newval)
    if self[:extended] != newval
      changed
      self[:extended] = newval
    end
    self[:extended]
  end

  def extended_html
    typo_deprecated "Use html(:extended)"
    html(:extended)
  end

  def self.html_map(field=nil)
    html_map = { :body => true, :extended => true }
    if field
      html_map[field.to_sym]
    else
      html_map
    end
  end

  def content_fields
    [:body, :extended]
  end

  protected

  before_create :set_defaults, :create_guid
  before_save :set_published_at
  after_save :keywords_to_tags
  after_create :add_notifications

  def set_published_at
    if self.published and self[:published_at].nil?
      self[:published_at] = self.created_at || Time.now
    end
  end

  def set_defaults
    if self.attributes.include?("permalink") and self.permalink.blank?
      self.permalink = self.stripped_title
    end
    if blog && self.allow_comments.nil?
      self.allow_comments = blog.default_allow_comments
    end

    if blog && self.allow_pings.nil?
      self.allow_pings = blog.default_allow_pings
    end

    true
  end

  def add_notifications
    self.notify_users = User.find_boolean(:all, :notify_on_new_articles)
    self.notify_users << self.user if (self.user.notify_watch_my_articles? rescue false)
    self.notify_users.uniq!
  end

  def self.time_delta(year, month = nil, day = nil)
    from = Time.mktime(year, month || 1, day || 1)

    to = from.next_year
    to = from.next_month unless month.blank?
    to = from + 1.day unless day.blank?
    to = to - 1 # pull off 1 second so we don't overlap onto the next day
    return [from, to]
  end

  def find_published(what = :all, options = {})
    super(what, options)
  end

  validates_uniqueness_of :guid
  validates_presence_of :title

  private

  def fix_resources
    Resource.find(:all, :conditions => "article_id = #{id}").each do |fu|
      fu.article_id = nil
      fu.save
    end
  end
end
