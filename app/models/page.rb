class Page < Content
  belongs_to :user
  validates_presence_of :name, :title, :body
  validates_uniqueness_of :name

  content_fields :body

  def self.default_order
    'name ASC'
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

  def edit_url
    blog.url_for(:controller => "/admin/pages", :action =>"edit", :id => id)
  end
  
  def delete_url
    blog.url_for(:controller => "/admin/pages", :action =>"destroy", :id => id)
  end
end
