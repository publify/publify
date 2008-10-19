class Tag < ActiveRecord::Base
  has_and_belongs_to_many :articles, :order => 'created_at DESC'
  validates_uniqueness_of :name
  attr_reader :description
  attr_reader :keywords
  
  def self.get(name)
    tagname = name.tr(' ', '').downcase
    tag = find_by_name_or_display_name(tagname, name)
    if tag.nil?
      tag = Tag.create(:name => tagname, :display_name => name)
    end

    tag
  end

  def self.find_by_name_or_display_name(tagname, name)
    self.find(:first, :conditions => [%{name = ? OR display_name = ? OR display_name = ?}, tagname, tagname, name])
  end

  def self.find_by_name(name, *args)
    self.send(:method_missing, :find_by_name, name, *args) ||
      self.new(:name => name)
  end

  def ensure_naming_conventions
    if self.display_name.blank?
      self.display_name = self.name
    end
    self.name = self.name.gsub('.', '-')
    self.name = self.name.gsub(' ', '').downcase
  end

  before_save :ensure_naming_conventions

  def self.find_all_with_article_counters(limit=20, orderby='article_counter DESC', start=0)
    # Only count published articles
    self.find_by_sql([%{
      SELECT tags.id, tags.name, tags.display_name, COUNT(articles_tags.article_id) AS article_counter
      FROM #{Tag.table_name} tags LEFT OUTER JOIN #{Tag.table_name_prefix}articles_tags#{Tag.table_name_suffix} articles_tags
        ON articles_tags.tag_id = tags.id
      LEFT OUTER JOIN #{Tag.table_name_prefix + Article.table_name + Tag.table_name_prefix} articles
        ON articles_tags.article_id = articles.id
      WHERE articles.published = ?
      GROUP BY tags.id, tags.name, tags.display_name
      ORDER BY #{orderby} 
      LIMIT ? OFFSET ? 
      },true, limit, start]).each{|item| item.article_counter = item.article_counter.to_i }
  end

  def self.merge(from, to)
    self.update_by_sql([%{UPDATE article_tags SET tag_id = #{to} WHERE tag_id = #{from} }])
  end

  def self.find_by_permalink(*args)
    self.find_by_name(*args) || new(:name => args.first)
  end

  def self.to_prefix
    'tag'
  end
   
  # Return all tags with the char or string 
  # send by parameter
  def self.find_with_char(char)
    find :all, :conditions => ['name LIKE ? ', "%#{char}%"], :order => 'name ASC'
  end
  
  def published_articles
    articles.find_already_published
  end

  def permalink
    self.name
  end

  def permalink_url(anchor=nil, only_path=true)
    blog = Blog.default # remove me...

    blog.url_for(
      :controller => 'tags',
      :action => 'show',
      :id => permalink
    )
  end

  def to_atom(xml)
    xml.category :term => display_name, :scheme => permalink_url
  end

  def to_rss(xml)
    xml.category display_name
  end

  def to_param
    permalink
  end
  
end
