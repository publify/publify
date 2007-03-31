class Category < ActiveRecord::Base
  acts_as_list
  has_many :categorizations
  has_many :articles, :through => :categorizations,
    :order => "published_at DESC, created_at DESC"
  attr_accessor :article_counter

  def self.find_all_with_article_counters(maxcount=nil)
    self.find(:all, :include => :articles, :conditions => ['contents.published = ?', true], :order => 'position').each { |cat| cat.update_attributes(:article_counter => cat.articles.length) }
  end

  def self.find(*args)
    with_scope :find => {:order => 'position ASC'} do
      super
    end
  end

  def self.find_by_permalink(*args)
    super || new
  end

  def self.to_prefix
    'category'
  end

  def stripped_name
    self.name.to_url
  end

  def self.reorder(serialized_list)
    self.transaction do
      serialized_list.each_with_index do |cid,index|
        find(cid).update_attribute "position", index
      end
    end
  end

  def self.reorder_alpha
    reorder find(:all, :order => 'UPPER(name)').collect { |c| c.id }
  end

  def published_articles
    self.articles.find_already_published
  end

  def display_name
    name
  end

  def permalink_url(anchor=nil, only_path=true)
    blog = Blog.find(1) # remove me...

    blog.url_for(
      :controller => '/articles',
      :action => 'category',
      :id => permalink
    )
  end

  protected

  before_save :set_defaults

  def set_defaults
    self.permalink ||= self.stripped_name
  end

  validates_presence_of :name
  validates_uniqueness_of :name, :on => :create
end

