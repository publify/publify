require 'uri'
require 'net/http'

class Article < Content
  include TypoGuid

  content_fields :body, :extended

  has_many :pings, :dependent => true, :order => "created_at ASC"
  has_many :comments, :dependent => true, :order => "created_at ASC"
  has_many :trackbacks, :dependent => true, :order => "created_at ASC"
  has_many :resources, :order => "created_at DESC",
           :class_name => "Resource", :foreign_key => 'article_id'
  has_and_belongs_to_many :categories, :foreign_key => 'article_id'
  has_and_belongs_to_many :tags, :foreign_key => 'article_id'
  belongs_to :user
  has_many :triggers, :as => :pending_item

  after_destroy :fix_resources

  def stripped_title
    self.title.gsub(/<[^>]*>/,'').to_url
  end

  def location(anchor=nil, only_path=true)
    blog.article_url(self, only_path, anchor)
  end

  def html_urls
    urls = Array.new
    (body_html.to_s + extended_html.to_s).gsub(/<a [^>]*>/) do |tag|
      if(tag =~ /href="([^"]+)"/)
        urls.push($1)
      end
    end

    urls
  end

  def really_send_pings(serverurl = blog.server_url, articleurl = location(nil, false))
    return unless blog.send_outbound_pings

    weblogupdatesping_urls = blog.ping_urls.gsub(/ +/,'').split(/[\n\r]+/)
    pingback_or_trackback_urls = self.html_urls

    ping_urls = weblogupdatesping_urls + pingback_or_trackback_urls

    ping_urls.uniq.each do |url|
      begin
        unless pings.collect { |p| p.url }.include?(url.strip)
          ping = pings.build("url" => url)

          if weblogupdatesping_urls.include?(url)
            ping.send_weblogupdatesping(serverurl, articleurl)
          else pingback_or_trackback_urls.include?(url)
            ping.send_pingback_or_trackback(articleurl)
          end
        end
      rescue
        # in case the remote server doesn't respond or gives an error,
        # we should throw an xmlrpc error here.
      end
    end
  end

  def send_pings
    state.send_pings(self)
  end

  def next
    Article.find(:first, :conditions => ['published_at > ?', published_at],
                 :order => 'published_at asc')
  end

  def previous
    Article.find(:first, :conditions => ['published_at < ?', published_at],
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
      keywords.to_s.scan(/((['"]).*?\2|\w+)/).collect do |x|
        x.first.tr("\"'", '')
      end.uniq.each do |tagword|
        tags << Tag.get(tagword)
      end
    end
  end

  def interested_users
    User.find_boolean(:all, :notify_on_new_articles)
  end

  def notify_user_via_email(controller, user)
    if user.notify_via_email?
      EmailNotify.send_article(controller, self, user)
    end
  end

  def notify_user_via_jabber(controller, user)
    if user.notify_via_jabber?
      JabberNotify.send_message(user, "New post",
                                "A new message was posted to #{blog.blog_name}",
                                content.body_html)
    end
  end

  protected

  before_create :set_defaults, :create_guid, :add_notifications
  after_save :keywords_to_tags

  def correct_counts
    self.comments_count = self.comments_count
    self.trackbacks_count = self.trackbacks_count
  end

  def set_defaults
    if self.attributes.include?("permalink") and self.permalink.blank?
      self.permalink = self.stripped_title
    end
    correct_counts
    if blog && self.allow_comments.nil?
      self.allow_comments = blog.default_allow_comments
    end

    if blog && self.allow_pings.nil?
      self.allow_pings = blog.default_allow_pings
    end
    true
  end

  def add_notifications
    # Grr, how do I do :conditions => 'notify_on_new_articles = true' when on MySQL boolean DB tables
    # are integers, Postgres booleans are booleans, and sqlite is basically just a string?
    #
    # I'm punting for now and doing the test in Ruby.  Feel free to rewrite.

    self.notify_users = User.find_boolean(:all, :notify_on_new_articles)
    self.notify_users << self.user if (self.user.notify_watch_my_articles? rescue false)
    self.notify_users.uniq!
  end

  def default_text_filter_config_key
    'text_filter'
  end

  def self.time_delta(year, month = nil, day = nil)
    from = Time.mktime(year, month || 1, day || 1)

    to = from.next_year
    to = from.next_month unless month.blank?
    to = from + 1.day unless day.blank?
    to = to - 1 # pull off 1 second so we don't overlap onto the next day
    return [from, to]
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
