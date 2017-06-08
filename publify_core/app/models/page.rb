class Page < Content
  validates :title, :body, presence: true
  validates :name, uniqueness: true

  include ConfigManager

  serialize :settings, Hash
  setting :password, :string, ''

  before_save :set_permalink
  after_save :shorten_url

  def set_permalink
    self.name = title.to_permalink if name.blank?
  end

  content_fields :body

  def self.default_order
    'title ASC'
  end

  def permalink_url(anchor = nil, only_path = false)
    blog.url_for(
      controller: '/articles',
      action: 'view_page',
      name: name,
      anchor: anchor,
      only_path: only_path
    )
  end

  def publish!
    self.state = 'published'
    save!
  end

  def published?
    state == 'published'
  end
end
