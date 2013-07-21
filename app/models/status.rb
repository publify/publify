class Status < Content
  belongs_to :user
  validates_presence_of :body
  validates_uniqueness_of :permalink
  attr_accessor :push_to_twitter
  
  after_create :set_permalink, :shorten_url

  default_scope order("created_at DESC")  

  def set_permalink
    self.permalink = "#{self.id}-#{self.body.to_permalink}" if self.permalink.nil? or self.permalink.empty?
    self.save
  end

  def set_author(user)
    self.author = user.login
    self.user = user
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

  def access_by?(user)
    user.admin? || user_id == user.id
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
