require 'uri'
require 'net/http'

class Article < Content
  include TypoGuid

  content_fields :body, :extended

  has_many :pings,      :dependent => :destroy, :order => "created_at ASC"

  has_many :comments,   :dependent => :destroy, :order => "created_at ASC" do

    # Get only ham or presumed_ham comments
    def ham
      find :all, :conditions => {:state => ["presumed_ham", "ham"]}
    end

    # Get only spam or presumed_spam comments
    def spam
      find :all, :conditions => {:state => ["presumed_spam", "spam"]}
    end

  end

  with_options(:conditions => { :published => true }, :order => 'created_at DESC') do |this|
    this.has_many :published_comments,   :class_name => "Comment", :order => "created_at ASC"
    this.has_many :published_trackbacks, :class_name => "Trackback", :order => "created_at ASC"
    this.has_many :published_feedback,   :class_name => "Feedback", :order => "created_at ASC"
  end

  has_many :trackbacks, :dependent => :destroy, :order => "created_at ASC"

  #TODO: change it because more logical with s in end : feedbacks
  has_many :feedback, :order => "created_at DESC"

  has_many :resources, :order => "created_at DESC",
           :class_name => "Resource", :foreign_key => 'article_id'
  after_destroy :fix_resources

  has_many :categorizations
  has_many :categories, \
    :through => :categorizations, \
    :include => :categorizations, \
    :select => 'categories.*', \
    :uniq => true, \
    :order => 'categorizations.is_primary DESC'

  has_and_belongs_to_many :tags, :foreign_key => 'article_id'

  named_scope :category, lambda {|category_id| {:conditions => ['categorizations.category_id = ?', category_id], :include => 'categorizations'}}
  named_scope :drafts, :conditions => ['state = ?', 'draft']


  belongs_to :user

  has_many :triggers, :as => :pending_item
  after_save :post_trigger

  attr_accessor :draft

  has_state(:state,
            :valid_states  => [:new, :draft,
                               :publication_pending, :just_published, :published,
                               :just_withdrawn, :withdrawn],
            :initial_state =>  :new,
            :handles       => [:withdraw,
                               :post_trigger,
                               :after_save, :send_pings, :send_notifications,
                               :published_at=, :just_published?])


  include Article::States

  class << self
    def published_articles
      find(:conditions => { :published => true }, :order => 'published_at DESC')
    end

    def count_published_articles
      count(:conditions => { :published => true })
    end

    def search_no_draft_paginate(search_hash, paginate_hash)
      list_function  = ["Article.no_draft"] + function_search_no_draft(search_hash)

      if search_hash[:category] and search_hash[:category].to_i > 0
        list_function << 'category(search_hash[:category])'
      end

      paginate_hash[:order] = 'created_at DESC'
      list_function << "paginate(paginate_hash)"
      eval(list_function.join('.'))
    end

  end

  accents = { ['á','à','â','ä','ã','Ã','Ä','Â','À'] => 'a',
    ['é','è','ê','ë','Ë','É','È','Ê'] => 'e',
    ['í','ì','î','ï','I','Î','Ì'] => 'i',
    ['ó','ò','ô','ö','õ','Õ','Ö','Ô','Ò'] => 'o',
    ['œ'] => 'oe',
    ['ß'] => 'ss',
    ['ú','ù','û','ü','U','Û','Ù'] => 'u',
    ['ç','Ç'] => 'c'
  }

  FROM, TO = accents.inject(['','']) { |o,(k,v)|
    o[0] << k * '';
    o[1] << v * k.size
    o
  }

  def stripped_title
    CGI.escape(self.title.tr(FROM, TO).gsub(/<[^>]*>/, '').to_url)
  end

  def year_url
    published_at.year.to_s
  end

  def month_url
    sprintf("%.2d", published_at.month)
  end

  def day_url
    sprintf("%.2d", published_at.day)
  end

  def title_url
    permalink.to_s
  end

  def permalink_url_options(nesting = false)
    format_url = blog.permalink_format.dup
    format_url.gsub!('%year%', year_url)
    format_url.gsub!('%month%', month_url)
    format_url.gsub!('%day%', day_url)
    format_url.gsub!('%title%', title_url)
    if format_url[0,1] == '/'
      format_url[1..-1]
    else
      format_url
    end
  end

  def permalink_url(anchor=nil, only_path=true)
    @cached_permalink_url ||= {}

    @cached_permalink_url["#{anchor}#{only_path}"] ||= \
      blog.url_for(permalink_url_options, :anchor => anchor, :only_path => only_path)
  end

  def param_array
    @param_array ||=
      returning([published_at.year,
                 sprintf('%.2d', published_at.month),
                 sprintf('%.2d', published_at.day),
                 permalink]) \
      do |params|
        this = self
        k = class << params; self; end
        k.send(:define_method, :to_s) { params[-1] }
      end
  end

  def to_param
    param_array
  end

  def trackback_url
    blog.url_for("trackbacks?article_id=#{self.id}", :only_path => true)
  end

  def permalink_by_format(format=nil)
    if format.nil?
      permalink_url
    elsif format.to_sym == :rss
      feed_url(:rss)
    elsif format.to_sym == :atom
      feed_url(:atom)
    else
      raise UnSupportedFormat
    end
  end

  def comment_url
    blog.url_for("comments?article_id=#{self.id}", :only_path => true)
  end

  def preview_comment_url
    blog.url_for("comments/preview?article_id=#{self.id}", :only_path => true)
  end

  def feed_url(format = :rss20)
    format_extension = format.to_s.gsub(/\d/,'')
    permalink_url + ".#{format_extension}"
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

    articleurl ||= permalink_url(nil)

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
    self.class.find(:first, :conditions => ['published_at > ?', published_at],
                    :order => 'published_at asc')
  end

  def previous
    self.class.find(:first, :conditions => ['published_at < ?', published_at],
                    :order => 'published_at desc')
  end

  # Count articles on a certain date
  def self.count_by_date(year, month = nil, day = nil, limit = nil)
    if !year.blank?
      count(:conditions => { :published_at => time_delta(year, month, day),
              :published => true })
    else
      count(:conditions => { :published => true })
    end
  end

  def self.find_by_published_at
    super(:published_at)
  end

  # Finds one article which was posted on a certain date and matches the supplied dashed-title
  # params is a Hash
  def self.find_by_permalink(params)
    date_range = self.time_delta(params[:year], params[:month], params[:day])
    req_params = {}
    if params[:title]
      req_params[:permalink] = params[:title]
    end

    if date_range
      req_params[:published_at] = date_range
    end
    return nil if req_params.empty? # no search if no params send

    find_published(:first, :conditions => req_params) or raise ActiveRecord::RecordNotFound
  end

  def self.find_by_params_hash(params = {})
    params[:title] ||= params[:article_id]
    find_by_permalink(params)
  end

  # Fulltext searches the body of published articles
  def self.search(query, args={})
    query_s = query.to_s.strip
    if !query_s.empty? && args.empty?
      Article.searchstring(query)
    elsif !query_s.empty? && !args.empty?
      Article.searchstring(query).paginate(args)
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

  def comments_closed?
    !(allow_comments? && in_feedback_window?)
  end

  def pings_closed?
    !(allow_pings? && in_feedback_window?)
  end

  # check if time to comment is open or not
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

  def extended=(newval)
    if self[:extended] != newval
      changed if published?
      self[:extended] = newval
    end
    self[:extended]
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

  # The web interface no longer distinguishes between separate "body" and
  # "extended" fields, and instead edits everything in a single edit field,
  # separating the extended content using "<!--more-->".
  def body_and_extended
    if extended.nil? || extended.empty?
      body
    else
      body + "\n<!--more-->\n" + extended
    end
  end

  # Split apart value around a "<!--more-->" comment and assign it to our
  # #body and #extended fields.
  def body_and_extended= value
    parts = value.split(/\n?<!--more-->\n?/, 2)
    self.body = parts[0]
    self.extended = parts[1] || ''
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
    if self.user && self.user.name
      rss_desc = "<hr /><p><small>#{_('Original article writen by')} #{self.user.name} #{_('and published on')} <a href='#{blog.base_url}'>#{blog.blog_name}</a> | <a href='#{self.permalink_url}'>#{_('direct link to this article')}</a> | #{_('If you are reading this article elsewhere than')} <a href='#{blog.base_url}'>#{blog.blog_name}</a>, #{_('it has been illegally reproduced and without proper authorization')}.</small></p>"
    else
      rss_desc = ""
    end
    
    # This HTMLEntities is use to convert bad entities on dabase. We can check 
    # some bad data insert by FCKEditor. We can found to &eacute; by exemple.
    # If we doesn't change that, the atom feed is invalid
    coder = HTMLEntities.new
    post = coder.decode(html(blog.show_extended_on_rss ? :all : :body))
    content = blog.rss_description ? post + rss_desc : post

    xml.summary "type" => "xhtml" do
      xml.div(:xmlns => "http://www.w3.org/1999/xhtml") {xml << coder.decode(html(:body)) }
    end
    if blog.show_extended_on_rss
      xml.content(:type => "xhtml") do
        xml.div(:xmlns => 'http://www.w3.org/1999/xhtml') { xml << content }
      end
    end
  end

  def add_comment(params)
    comments.build(params)
  end

  def add_category(category, is_primary = false)
    self.categorizations.build(:category => category, :is_primary => is_primary)
  end

  def access_by?(user) 
    user.admin? || user_id == user.id 
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
    if self.attributes.include?("permalink") and 
          (self.permalink.blank? or 
          self.permalink.to_s =~ /article-draft/ or 
          self.state == "draft"
    )
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

  def self.time_delta(year = nil, month = nil, day = nil)
    return nil if year.nil? && month.nil? && day.nil?
    from = Time.mktime(year, month || 1, day || 1)

    to = from.next_year
    to = from.next_month unless month.blank?
    to = from + 1.day unless day.blank?
    to = to - 1 # pull off 1 second so we don't overlap onto the next day
    return from..to
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
