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
end