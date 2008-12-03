class Page < Content
  belongs_to :user
  validates_presence_of :name, :title, :body
  validates_uniqueness_of :name

  content_fields :body

  def self.default_order
    'name ASC'
  end

  def self.search_paginate(search_hash, paginate_hash)
    list_function = ["Page"] + function_search_no_draft(search_hash)
    paginate_hash[:order] = 'title ASC'
    list_function << "paginate(paginate_hash)"
    eval(list_function.join('.'))
  end

  typo_deprecate :location => :permalink_url
  
  def permalink_url(anchor=nil, only_path=true)
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


  def edit_url
    blog.url_for(:controller => "/admin/pages", :action =>"edit", :id => id)
  end
  
  def delete_url
    blog.url_for(:controller => "/admin/pages", :action =>"destroy", :id => id)
  end
end
