class Tag < ActiveRecord::Base
  has_and_belongs_to_many :articles, :order => 'created_at DESC'

  validates_uniqueness_of :name

  before_save :ensure_naming_conventions

  attr_accessor :description, :keywords

  def self.get(name)
    tagname = name.to_url
    find_or_create_by_name(tagname, :display_name => name)
  end

  def self.find_by_name_or_display_name(tagname, name)
    where(%{name = ? OR display_name = ? OR display_name = ?}, tagname, tagname, name).first
  end

  def ensure_naming_conventions
    if self.display_name.blank?
      self.display_name = self.name
    end
    self.name = self.display_name.to_url
  end

  def self.find_all_with_article_counters
    self.find_by_sql([%{
      SELECT tags.id, tags.name, tags.display_name, COUNT(articles_tags.article_id) AS article_counter
      FROM #{Tag.table_name} tags LEFT OUTER JOIN #{Tag.table_name_prefix}articles_tags#{Tag.table_name_suffix} articles_tags
        ON articles_tags.tag_id = tags.id
      LEFT OUTER JOIN #{Tag.table_name_prefix + Article.table_name + Tag.table_name_prefix} articles
        ON articles_tags.article_id = articles.id
      WHERE articles.published = ?
      GROUP BY tags.id, tags.name, tags.display_name
      ORDER BY article_counter DESC
      LIMIT ? OFFSET ?
      },true, 1000, 0]).each{|item| item.article_counter = item.article_counter.to_i }
  end

  def self.find_by_permalink(name)
    self.find_by_name(name)
  end

  def self.find_with_char(char)
    where('name LIKE ? ', "%#{char}%").order('name ASC')
  end

  def self.collection_to_string tags
    tags.map(&:display_name).sort.map { |name| name =~ / / ? "\"#{name}\"" : name }.join ", "
  end

  def published_articles
    articles.already_published
  end

  def permalink
    self.name
  end

  def permalink_url(anchor=nil, only_path=false)
    blog = Blog.default # remove me...
    blog.url_for(controller: 'tags', action: 'show', id: permalink, only_path: only_path)
  end

end
