require 'uri'
require 'net/http'

class Article < Content
  include TypoGuid

  content_fields :body, :extended

  has_many :pings,      :dependent => :destroy, :order => "created_at ASC"
  has_many :comments,   :dependent => :destroy, :order => "created_at ASC"
  with_options(:conditions => { :published => true }, :order => 'created_at DESC') do |this|
    this.has_many :published_comments,   :class_name => "Comment", :order => "created_at ASC"
    this.has_many :published_trackbacks, :class_name => "Trackback", :order => "created_at ASC"
    this.has_many :published_feedback,   :class_name => "Feedback", :order => "created_at ASC"
  end
  has_many :trackbacks, :dependent => :destroy, :order => "created_at ASC"
  has_many :feedback,                           :order => "created_at DESC"
  has_many :resources, :order => "created_at DESC",
           :class_name => "Resource", :foreign_key => 'article_id'
  
  has_many :categorizations
  has_many :categories, \
    :through => :categorizations, \
    :uniq => true, \
    :order => 'categorizations.is_primary DESC, categories.position'
  
  has_and_belongs_to_many :tags, :foreign_key => 'article_id'
  belongs_to :user
  has_many :triggers, :as => :pending_item

  after_save :post_trigger
  after_destroy :fix_resources

  has_state(:state,
            :valid_states  => [:new, :draft,
                               :publication_pending, :just_published, :published,
                               :just_withdrawn, :withdrawn],
            :initial_state =>  :new,
            :handles       => [:withdraw,
                               :post_trigger,
                               :after_save, :send_pings, :send_notifications,
                               :published_at=, :just_published?])


  include States

  def stripped_title
    str = String.new(self.title)
    
    accents = { ['á','à','â','ä','ã','Ã','Ä','Â','À'] => 'a',
      ['é','è','ê','ë','Ë','É','È','Ê'] => 'e',
      ['í','ì','î','ï','I','Î','Ì'] => 'i',
      ['ó','ò','ô','ö','õ','Õ','Ö','Ô','Ò'] => 'o',
      ['œ'] => 'oe',
      ['ß'] => 'ss',
      ['ú','ù','û','ü','U','Û','Ù'] => 'u',
      ['ç','Ç'] => 'c'
      }
    accents.each do |ac,rep|
      ac.each do |s|
        str.gsub!(s, rep)
      end
    end
    
    str.gsub(/<[^>]*>/,'').to_url
  end
  
  def permalink_url_options(nesting = false)
    {:year => published_at.year,
     :month => sprintf("%.2d", published_at.month),
     :day => sprintf("%.2d", published_at.day),
     :controller => 'articles',
     :action => 'show',
     (nesting ? :article_id : :id) => permalink}
  end

  def permalink_url(anchor=nil, only_path=true)
    @cached_permalink_url ||= {}
    @cached_permalink_url["#{anchor}#{only_path}"] ||= \
      blog.with_options(permalink_url_options) do |b|
        b.url_for(:anchor => anchor, :only_path => only_path)
      end
  end

  def param_array
    @param_array ||=
      returning([published_at.year, sprintf('%.2d', published_at.month),
                 sprintf('%.2d', published_at.day), permalink]) do |params|
      this = self
      k = class << params; self; end
      k.send(:define_method, :to_s) { params[-1] }
    end
  end

  def to_param
    param_array
  end

  def trackback_url
    blog.url_for(permalink_url_options(true).merge(:controller => 'trackbacks', :action => 'index'))
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
    if !year.blank?
      from, to = self.time_delta(year, month, day)
      Article.count(["published_at BETWEEN ? AND ? AND published = ?",
                     from, to, true])
    else
      Article.count(:conditions => { :published => true })
    end
  end

  # Find all articles on a certain date
  def self.find_all_by_date(year, month = nil, day = nil)
    if !year.blank?
      from, to = self.time_delta(year, month, day)
      Article.find_published(:all, :conditions => ["published_at BETWEEN ? AND ?",
                                                   from, to])
    else
      Article.find_published(:all)
    end
  end

  # Find one article on a certain date

  def self.find_by_date(year, month, day)
    find_all_by_date(year, month, day).first
  end

  def self.date_from(params_hash)
    params_hash[:article_year] \
      ? params_hash.values_at(:article_year, :article_month, :article_day, :article_id) \
      : params_hash.values_at(:year, :month, :day, :id)
  end

  # Finds one article which was posted on a certain date and matches the supplied dashed-title
  def self.find_by_permalink(year, month=nil, day=nil, title=nil)
    unless month
      case year
      when Hash
        year, month, day, title = date_from(year)
      when Array
        year, month, day, title = year
      end
    end
    from, to = self.time_delta(year, month, day)
    returning(find_published(:first,
                             :conditions => ['permalink = ? AND ' +
                                             'published_at BETWEEN ? AND ?',
                                             title, from, to ])) do |res|
      if res.nil?
        raise ActiveRecord::RecordNotFound
      end
    end
  end

  def self.find_by_params_hash(params = {})
    params[:id] ||= params[:article_id]
    if params[:id]
      find_by_permalink(params)
    else
      find_by_date(*date_from(params))
    end
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
      JabberNotify.send_message(user, _("New post"),
                                _("A new message was posted to ") +  blog.blog_name,
                                html(:body))
    end
  end

  def comments_closed?
    !(allow_comments? && in_feedback_window?)
  end

  def in_feedback_window?
    self.blog.sp_article_auto_close.zero? ||
      self.created_at.to_i > self.blog.sp_article_auto_close.days.ago.to_i
  end

  def cast_to_boolean(value)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
  end
  # Cast the input value for published= before passing it to the state.
  def published=(newval)
    state.published = cast_to_boolean(newval)
  end

  # Bloody rails reloading. Nasty workaround.
  def allow_comments=(newval)
    returning(cast_to_boolean(newval)) do |val|
      if self[:allow_comments] != val
        changed if published?
        self[:allow_comments] = val
      end
    end
  end

  def allow_pings=(newval)
    returning(cast_to_boolean(newval)) do |val|
      if self[:allow_pings] != val
        changed if published?
        self[:allow_pings] = val
      end
    end
  end

  def body=(newval)
    if self[:body] != newval
      changed if published?
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
      changed if published?
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

  ## Feed Stuff
  def rss_trackback(xml)
    return unless allow_pings?
    xml.trackback :ping, trackback_url
  end

  def rss_enclosure(xml)
    return if resources.empty?
    res = resources.first
    xml.enclosure(:url    => blog.file_url(res.filename),
                  :length => res.size,
                  :type   => res.mime)
  end

  def rss_groupings(xml)
    categories.each { |v| v.to_rss(xml) }
    tags.each       { |v| v.to_rss(xml) }
  end

  def rss_author(xml)
    if link_to_author?
      xml.author("#{user.email} (#{user.name})")
    end
  end

  def rss_comments(xml)
    xml.comments(permalink_url + "#comments")
  end

  def link_to_author?
    !user.email.blank? && blog.link_to_author
  end

  def rss_title(xml)
    xml.title title
  end

  def atom_author(xml)
    xml.author { xml.name user.name }
  end

  def atom_title(xml)
    xml.title title, "type" => "html"
  end

  def atom_groupings(xml)
    categories.each {|v| v.to_atom(xml) }
    tags.each { |v| v.to_atom(xml) }
  end

  def atom_enclosures(xml)
    resources.each do |value|
      xml.with_options(value.size > 0 ? { :length => value.size } : { }) do |xm|
        xm.link "rel" => "enclosure",
        :type => value.mime,
        :title => title,
        :href => blog.file_url(value.filename)
      end
    end
  end

  def atom_content(xml)
    xml.summary html(:body), "type" => "html"
    if blog.show_extended_on_rss
      xml.content html(:all), "type" => "html"
    end
  end

  def add_comment(params)
    comments.build(params)
  end
  
  def add_category(category, is_primary = false)
    self.categorizations.build(:category => category, :is_primary => is_primary)
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
