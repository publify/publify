module BloggerStructs
  class Blog < ActionWebService::Struct
    member :url,      :string
    member :blogid,   :string
    member :blogName, :string
  end
  class User < ActionWebService::Struct
    member :userid, :string
    member :firstname, :string
    member :lastname, :string
    member :nickname, :string
    member :email, :string
    member :url, :string
  end
end


class BloggerApi < ActionWebService::API::Base
  inflect_names false

  api_method :deletePost,
    :expects => [ {:appkey => :string}, {:postid => :int}, {:username => :string}, {:password => :string},
                  {:publish => :bool} ],
    :returns => [:bool]

  api_method :getUserInfo,
    :expects => [ {:appkey => :string}, {:username => :string}, {:password => :string} ],
    :returns => [BloggerStructs::User]
    
  api_method :getUsersBlogs,
    :expects => [ {:appkey => :string}, {:username => :string}, {:password => :string} ],
    :returns => [[BloggerStructs::Blog]]

  api_method :newPost,
    :expects => [ {:appkey => :string}, {:blogid => :string}, {:username => :string}, {:password => :string},
                  {:content => :string}, {:publish => :bool} ],
    :returns => [:int]
end


class BloggerService < TypoWebService
  web_service_api BloggerApi
  before_invocation :authenticate  
  
  def deletePost(appkey, postid, username, password, publish)
    article = Article.find(postid)
    article.destroy
    true
  end
  
  def getUserInfo(appkey, username, password)
    BloggerStructs::User.new(
      :userid => username,
      :firstname => "",
      :lastname => "",
      :nickname => username,
      :email => "",
      :url => controller.url_for(:controller => "/")
    )
  end
  
  def getUsersBlogs(appkey, username, password)
    [BloggerStructs::Blog.new(
      :url      => controller.url_for(:controller => "/"),
      :blogid   => 1,
      :blogName => config[:blog_name]
    )]
  end

  def newPost(appkey, blogid, username, password, content, publish)
    title, categories, body = content.match(%r{^<title>(.+?)</title>(?:<category>(.+?)</category>)?(.+)$}mi).captures rescue nil

    article = Article.new 
    article.body        = body || content || ''
    article.title       = title || content.split.slice(0..5).join(' ') || ''
    article.published   = publish
    article.author      = username
    article.created_at  = Time.now
    article.user        = @user
    article.allow_comments = config[:default_allow_comments]
    article.allow_pings    = config[:default_allow_pings]
    article.text_filter    = config[:text_filter]
    article.html(@controller)
    article.save

    if categories
      categories.split(",").each do |c|
        article.categories << Category.find_by_name(c.strip) rescue nil
      end
    end

    article.send_notifications(@controller)
    article.id
  end
  
end
