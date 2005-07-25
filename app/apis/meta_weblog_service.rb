module MetaWeblogStructs
  class Article < ActionWebService::Struct
    member :description,        :string
    member :title,              :string
    member :postid,             :string
    member :url,                :string
    member :link,               :string
    member :permaLink,          :string
    member :categories,         [:string]
    member :mt_text_more,       :string
    member :mt_excerpt,         :string
    member :mt_keywords,        :string
    member :mt_allow_comments,  :int
    member :mt_allow_pings,     :int
    member :mt_convert_breaks,  :string
    member :mt_tb_ping_urls,    [:string]
    member :dateCreated,        :time
  end

  class MediaObject < ActionWebService::Struct
    member :bits, :string
    member :name, :string
    member :type, :string
  end

  class Url < ActionWebService::Struct
    member :url, :string
  end
end


class MetaWeblogApi < ActionWebService::API::Base
  inflect_names false

  api_method :getCategories,
    :expects => [ {:blogid => :string}, {:username => :string}, {:password => :string} ],
    :returns => [[:string]]

  api_method :getPost,
    :expects => [ {:postid => :string}, {:username => :string}, {:password => :string} ],
    :returns => [MetaWeblogStructs::Article]

  api_method :getRecentPosts,
    :expects => [ {:blogid => :string}, {:username => :string}, {:password => :string}, {:numberOfPosts => :int} ],
    :returns => [[MetaWeblogStructs::Article]]

  api_method :deletePost,
    :expects => [ {:appkey => :string}, {:postid => :string}, {:username => :string}, {:password => :string}, {:publish => :int} ],
    :returns => [:bool]

  api_method :editPost,
    :expects => [ {:postid => :string}, {:username => :string}, {:password => :string}, {:struct => MetaWeblogStructs::Article}, {:publish => :int} ],
    :returns => [:bool]

  api_method :newPost,
    :expects => [ {:blogid => :string}, {:username => :string}, {:password => :string}, {:struct => MetaWeblogStructs::Article}, {:publish => :int} ],
    :returns => [:string]

  api_method :newMediaObject,
    :expects => [ {:blogid => :string}, {:username => :string}, {:password => :string}, {:data => MetaWeblogStructs::MediaObject} ],
    :returns => [MetaWeblogStructs::Url]

end


class MetaWeblogService < TypoWebService
  web_service_api MetaWeblogApi
  
  before_invocation :authenticate  
  attr_reader :controller

  def initialize(controller)
    @controller = controller
  end

  def getCategories(blogid, username, password)
    Category.find_all.collect { |c| c.name }
  end

  def getPost(postid, username, password)
    article = Article.find(postid)
                    
    article_dto_from(article)
  end    

  def getRecentPosts(blogid, username, password, numberOfPosts)
    Article.find(:all, :order => "created_at DESC", :limit => numberOfPosts).collect{ |c| article_dto_from(c) }
  end

  def newPost(blogid, username, password, struct, publish)
    article = Article.new 
    article.body        = struct['description'] || ''
    article.title       = struct['title'] || ''
    article.published   = publish ? 1 : 0
    article.author      = username
    article.created_at  = Time.now
    article.user        = @user

    # Movable Type API support
    article.allow_comments = struct['mt_allow_comments'] || $config['default_allow_comments']
    article.allow_pings    = struct['mt_allow_pings'] || $config['default_allow_pings']
    article.extended       = struct['mt_text_more'] || ''
    article.excerpt        = struct['mt_excerpt'] || ''
    article.keywords       = struct['mt_keywords'] || ''
    article.text_filter    = struct['mt_convert_breaks'] || ''
    
    if struct['categories']
      article.categories.clear
      Category.find_all.each do |c|
        article.categories << c if struct['categories'].include?(c.name)
      end
    end

    article.send_pings(article_url(article), struct['mt_tb_ping_urls'])
    
    article.save
    article.id.to_s
  end
    
  def deletePost(appkey, postid, username, password, publish)
    article = Article.find(postid)
    article.destroy
    true
  end

  def editPost(postid, username, password, struct, publish)
    article = Article.find(postid)
    article.body        = struct['description'] || ''
    article.title       = struct['title'] || ''
    article.published   = publish ? 1 : 0
    article.author      = username
    # article.dateCreated

    # Movable Type API support
    article.allow_comments = struct['mt_allow_comments'] || $config['default_allow_comments']
    article.allow_pings    = struct['mt_allow_pings'] || $config['default_allow_pings']
    article.extended       = struct['mt_text_more'] || ''
    article.excerpt        = struct['mt_excerpt'] || ''
    article.keywords       = struct['mt_keywords'] || ''
    article.text_filter    = struct['mt_convert_breaks'] || ''

    if struct['categories']
      article.categories.clear
      Category.find_all.each do |c|
        article.categories << c if struct['categories'].include?(c.name)
      end
    end
    RAILS_DEFAULT_LOGGER.info(struct['mt_tb_ping_urls'])
    article.send_pings(article_url(article), struct['mt_tb_ping_urls'])

    article.save    
    true
  end
    
  def newMediaObject(blogid, username, password, data)
    path      = "#{RAILS_ROOT}/public/files/#{data["name"].split('/')[0..-2].join('/')}"
    filepath  = "#{RAILS_ROOT}/public/files/#{data["name"]}"
      
    FileUtils.mkpath(path)
      
    File.open(filepath, "wb") { |f| f << data["bits"] }

    resource = Resource.new
    resource.filename   = data["name"]
    resource.size       = File.size(path)
    resource.mime       = data["type"]    
    resource.save
      
    MetaWeblogStructs::Url.new("url" => controller.url_for(:controller => "/files/#{data["name"]}"))
  end             

  def article_dto_from(article)
    MetaWeblogStructs::Article.new(
      :description       => article.body,
      :title             => article.title,
      :postid            => article.id.to_s,
      :url               => article_url(article).to_s,
      :link              => article_url(article).to_s,
      :permaLink         => article_url(article).to_s,
      :categories        => article.categories.collect { |c| c.name },
      :mt_text_more      => article.extended.to_s,
      :mt_excerpt        => article.excerpt.to_s,
      :mt_keywords       => article.keywords.to_s,
      :mt_allow_comments => article.allow_comments.to_i,
      :mt_allow_pings    => article.allow_pings.to_i,
      :mt_convert_breaks => article.text_filter.to_s,
      :mt_tb_ping_urls   => article.pings.collect { |p| p.url },
      :dateCreated       => article.created_at || ""
      )
  end

  protected

  def article_url(article)
    begin
      controller.url_for :controller=>"/articles", :action =>"permalink",
        :year => article.created_at.year, :month => sprintf("%.2d", article.created_at.month),
        :day => sprintf("%.2d", article.created_at.day), :title => article.stripped_title
    rescue
      # FIXME: rescue is needed for functional tests as the test framework currently doesn't supply fully
      # fledged controller instances (yet?)
      "/articles/read/#{article.id}"
    end
  end

  def pub_date(time)
    time.strftime "%a, %e %b %Y %H:%M:%S %Z"
  end
end
