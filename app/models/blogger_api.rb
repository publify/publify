class BloggerApi
  
  attr_reader :request
  
  def initialize(request)
    @request = request
  end
  
  def deletePost(appkey, postid, username, password, publish)
    raise "Invalid login" unless valid_login?(username, password)
    article = Article.find(postid)
    article.destroy
    true
  end
  
  def getUsersBlogs(appkey, username, password)
    raise "Invalid login" unless valid_login?(username, password)

    [ {"url"=> server_url, "blogid" => 1, "blogName" => CONFIG['blogname']}]    
  end
  
  private
  
    def valid_login?(user,pass)
      user == CONFIG['login'] && pass == CONFIG['password']
    end
    
    def server_url
     "http://" << request.host << request.port_string 
    end
  
end