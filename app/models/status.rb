class Status < Content
  belongs_to :user
  validates_presence_of :body
  validates_uniqueness_of :permalink

  after_create :set_permalink, :shorten_url

  default_scope order("created_at DESC")  

  def set_permalink
    self.permalink = "#{self.id}-#{self.body.to_permalink}"
    self.save
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
    'id ASC'
  end

  def self.search_paginate(search_hash, paginate_hash)
    list_function = ["Page"] + function_search_all_posts(search_hash)
    paginate_hash[:order] = 'id ASC'
    list_function << "page(paginate_hash[:page])"
    list_function << "per(paginate_hash[:per_page])"
    eval(list_function.join('.'))
  end

  def permalink_url(anchor=nil, only_path=false)
    blog.url_for(
      :controller => '/statuses',
      :action => 'show',
      :permalink => permalink,
      :anchor => anchor,
      :only_path => only_path
    )
  end

end
