class MetaWeblogApi
  
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def newPost(blogid, username, password, struct, publish)
    raise "Invalid login" unless valid_login?(username, password)

    article = Article.new 
    article.body        = struct['description']
    article.title       = struct['title']
    article.published   = publish ? 1 : 0
    article.author      = username

    Category.find_all.each do |c|
      article.categories << c if struct['categories'].include?(c.name)
    end

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

    categories = Category.find_all()
    article.remove_categories(categories)
    categories.each do |c|
      article.categories << c if struct['categories'].include?(c.name)
    end
  
    article.save    
    true
  end
  
  def getCategories(blogid, username, password)
    raise "Invalid login" unless valid_login?(username, password)
    Category.find_all.collect { |c| c.name }
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
  

  def newMediaObject(blogid, username, password, data)
    raise "Invalid login" unless valid_login?(username, password)

    path      = "#{RAILS_ROOT}/public/files/#{data["name"].split('/')[0..-2].join('/')}"
    filepath  = "#{RAILS_ROOT}/public/files/#{data["name"]}"
    
    FileUtils.mkpath(path)
    
    File.open(filepath, "wb") { |f| f << data["bits"] }

    resource = Resource.new
    resource.filename   = data["name"]
    resource.size       = File.size(path)
    resource.mime       = data["type"]    
    resource.save
    
    { "url" => "#{server_url}/files/#{data["name"]}"}
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
        "url"           => "#{server_url}/articles/read/#{article.id}",
        "dateCreated"   => article.created_at,
        "categories"    => article.categories.collect { |c| c.name }
      }
  end
    
  def valid_login?(user,pass)
    user == CONFIG['login'] && pass == CONFIG['password']
  end
  
  def pub_date(time)
    time.strftime "%a, %e %b %Y %H:%M:%S %Z"
  end
  
  def server_url
     "http://" << request.host << request.port_string 
  end
   
   
end