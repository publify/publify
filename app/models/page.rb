class Page < Content
  validates_presence_of :title, :body
  validates_uniqueness_of :name

  include ConfigManager

  serialize :settings, Hash
  setting :password, :string, ''

  before_save :set_permalink
  after_save :shorten_url

  def set_permalink
    self.name = self.title.to_permalink if self.name.blank?
  end

  def initialize(*args)
    super
    # Yes, this is weird - PDC
    begin
      self.settings ||= {}
    rescue Exception => e
      self.settings = {}
    end
  end

  content_fields :body

  def self.default_order
    'name ASC'
  end

  def self.search_with(search_hash)
    super(search_hash).order('title ASC')
  end

  def permalink_url(anchor=nil, only_path=false)
    blog.url_for(
      :controller => '/articles',
      :action => 'view_page',
      :name => name,
      :anchor => anchor,
      :only_path => only_path
    )
  end

end
