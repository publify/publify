module BloggerStructs
  class Blog < ActionWebService::Struct
    member :url,      :string
    member :blogid,   :int
    member :blogName, :string
  end
end


class BloggerApi < ActionWebService::API::Base
  inflect_names false

  api_method :getUsersBlogs,
    :expects => [ {:appkey => :string}, {:username => :string}, {:password => :string} ],
    :returns => [[BloggerStructs::Blog]]

  api_method :deletePost,
    :expects => [ {:appkey => :string}, {:postid => :int}, {:username => :string}, {:password => :string}, {:publish => :int} ],
    :returns => [:bool]
end


class BloggerService < ActionWebService::Base
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
  
  def getUsersBlogs(appkey, username, password)
    [BloggerStructs::Blog.new(
      :url      => controller.url_for("/"),
      :blogid   => 1,
      :blogName => config['blog_name']
    )]
  end
  
  private

  # FIXME: This method can be rewritten using API::Method#expects_index_of and API::Method#expects_to_hash
  #       available in the next Rails release
  def authenticate(name, args)
    method_expects = self.class.web_service_api.api_methods[name][:expects]
    username, password = method_expects.index(:username=>String), method_expects.index(:password=>String)

    raise "Invalid login" unless User.authenticate?(args[username], args[password])
  end
  
end