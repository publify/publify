class MetaWeblogApi

  def newPost(blogid, username, password, struct, publish)
    raise "Invalid login" unless valid_login?(username, password)

    article = Article.new 
    article.body        = struct['description']
    article.title       = struct['title']
    article.published   = publish ? 1 : 0
    article.author      = username
  
    article.save    
    article.id.to_s
  end
  
  def deletePost(appkey, postid, username, password, publish)
    raise "Invalid login" unless valid_login?(username, password)
    article = Article.find(postid)
    article.destroy
    true
  end

  def editPost(postid, username, password, struct, publish)
    raise "Invalid login" unless valid_login?(username, password)

    article = Article.find(postid)
    article.body        = struct['description']
    article.title       = struct['title']
    article.published   = publish ? 1 : 0
    article.author      = username
  
    article.save    
    true
  end
  
  def getCategories(blogid, username, password)
    raise "Invalid login" unless valid_login?(username, password)
    Article.categories        
  end


  def getRecentPosts(blogid, username, password, numberOfPosts)
    raise "Invalid login" unless valid_login?(username, password)
  
    articles = Article.find_all(nil,"created_at DESC", numberOfPosts)
  
    array = []
  
    articles.each do |article|      
      array << item_from(article)
    end
  
    array          
  end

  def getPost(postid, username, password)
    raise "Invalid login" unless valid_login?(username, password)
  
    article = Article.find(postid)
                    
    item_from(article)
  end    
  
  private
  
  def item_from(article)
    item = {
        "description"   => article.body,
        "title"         => article.title,
        "postid"        => article.id.to_s,
        "url"           => "/articles/read/#{article.id}",
        "dateCreated"   => article.created_at
      }
  end
    
  def valid_login?(user,pass)
    user == CONFIG['login'] && pass == CONFIG['password']
  end
  
  def pub_date(time)
    time.strftime "%a, %e %b %Y %H:%M:%S %Z"
  end
   
end