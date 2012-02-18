class Page < Content
  belongs_to :user
  validates_presence_of :name, :title, :body
  validates_uniqueness_of :name

  include ConfigManager
  include Sanitizable

  serialize :settings, Hash
  setting :password, :string, ''

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

  def self.search_paginate(search_hash, paginate_hash)
    list_function = ["Page"] + function_search_no_draft(search_hash)
    paginate_hash[:order] = 'title ASC'
    list_function << "page(paginate_hash[:page])"
    list_function << "per(paginate_hash[:per_page])"
    
    eval(list_function.join('.'))
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

  def self.find_by_published_at
    super(:created_at)
  end

  def sanitized_title
    remove_accents(self.title).gsub(/<[^>]*>/, '').to_url
  end
end
