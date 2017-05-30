class Tag < ActiveRecord::Base
  belongs_to :blog
  has_and_belongs_to_many :contents, order: 'created_at DESC'

  validates :name, uniqueness: { scope: :blog_id }
  validates :blog, presence: true
  validates :name, presence: true

  before_validation :ensure_naming_conventions

  attr_accessor :description, :keywords

  def self.create_from_article!(article)
    return if article.keywords.nil?
    tags = []
    Tag.transaction do
      tagwords = article.keywords.to_s.scan(/((['"]).*?\2|[\.:[[:alnum:]]]+)/).map do |x|
        x.first.tr("\"'", '')
      end
      tagwords.uniq.each do |tagword|
        tagname = tagword.to_url
        tags << article.blog.tags.find_or_create_by(name: tagname) do |tag|
          tag.display_name = tagword
        end
      end
    end
    article.tags = tags
    tags
  end

  def ensure_naming_conventions
    self.display_name = name if display_name.blank?
    self.name = display_name.to_url if display_name.present?
  end

  def self.find_all_with_content_counters
    Tag.joins(:contents).
      where(contents: { state: 'published' }).
      select(*Tag.column_names, 'COUNT(contents_tags.content_id) as content_counter').
      group(*Tag.column_names).
      order('content_counter DESC').limit(1000)
  end

  def self.find_with_char(char)
    where('name LIKE ? ', "%#{char}%").order('name ASC')
  end

  def self.collection_to_string(tags)
    tags.map(&:display_name).sort.map { |name| name =~ / / ? "\"#{name}\"" : name }.join ', '
  end

  def published_contents
    contents.published
  end

  def permalink
    name
  end

  def permalink_url(_anchor = nil, only_path = false)
    blog.url_for(controller: 'tags', action: 'show', id: permalink, only_path: only_path)
  end
end
