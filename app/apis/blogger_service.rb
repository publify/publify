module BloggerStructs
  class Blog < ActionWebService::Struct
    member :url,      :string
    member :blogid,   :int
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
    :expects => [ {:appkey => :string}, {:postid => :int}, {:username => :string}, {:password => :string}, {:publish => :int} ],
    :returns => [:bool]

  api_method :getUserInfo,
    :expects => [ {:appkey => :string}, {:username => :string}, {:password => :string} ],
    :returns => [BloggerStructs::User]
    
  api_method :getUsersBlogs,
    :expects => [ {:appkey => :string}, {:username => :string}, {:password => :string} ],
    :returns => [[BloggerStructs::Blog]]
end


class BloggerService < TypoWebService
  web_service_api BloggerApi

  before_invocation :authenticate  
  attr_reader :controller
  
  def initialize(controller)
    @controller = controller
  end
  
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
      :blogName => config['blog_name']
    )]
  end
end