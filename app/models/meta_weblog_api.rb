class MetaWeblogApi
  
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def newPost(blogid, username, password, struct, publish)
    raise "Invalid login" unless valid_login?(username, password)

    article = Article.new 
    article.body        = struct['description'] || ''
    article.title       = struct['title'] || ''
    article.published   = publish ? 1 : 0
    article.author      = username
    # article.dateCreated

    # Moveable Type API support
    article.allow_comments = struct['mt_allow_comments'] || CONFIG['default_allow_comments']
    article.allow_pings    = struct['mt_allow_pings'] || CONFIG['default_allow_pings']
    #                      = struct['mt_convert_breaks']
    article.extended       = struct['mt_text_more'] || ''
    article.excerpt        = struct['mt_excerpt'] || ''
    article.keywords       = struct['mt_keywords'] || ''
    
    # Build new categories from the keywords
    #   Maybe we can try this and see if it works well (seth)
    #new_categories = article.keywords.split(",").collect { |x| x.strip }
    #Category.find_all.each do |c|
    #  new_categories.delete_if { |x| x == c.name }
    #end 
    #new_categories.each do |category|
    #  c = Category.new
    #  c.name = category
    #  c.save
    #end

    if struct.has_key?('categories')
      #struct['categories'] + new_categories 
      Category.find_all.each do |c|
        article.categories << c if struct['categories'].include?(c.name)
      end
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
    article.body        = struct['description'] || ''
    article.title       = struct['title'] || ''
    article.published   = publish ? 1 : 0
    article.author      = username
    # article.dateCreated

    # Moveable Type API support
    article.allow_comments = struct['mt_allow_comments'] || CONFIG['default_allow_comments']
    article.allow_pings    = struct['mt_allow_pings'] || CONFIG['default_allow_pings']
    #                      = struct['mt_convert_breaks']
    article.extended       = struct['mt_text_more'] || ''
    article.excerpt        = struct['mt_excerpt'] || ''
    article.keywords       = struct['mt_keywords'] || ''

    # Build new categories from the keywords
    #new_categories = article.keywords.split(",").collect { |x| x.strip }
    #Category.find_all.each do |c|
    #  new_categories.delete_if { |x| x == c.name }
    #end  
    #new_categories.each do |category|
    #  c = Category.new
    #  c.name = category
    #  c.save
    #end

    if struct.has_key?('categories')
      categories = Category.find_all()
      article.remove_categories(categories)
      #struct['categories'] + new_categories
      categories.each do |c|
        article.categories << c if struct['categories'].include?(c.name)
      end
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
  
    articles = Article.find_all(nil, "created_at DESC", numberOfPosts)
  
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
        "link"          => "#{server_url}/articles/read/#{article.id}",
        "permaLink"     => "#{server_url}/articles/read/#{article.id}",
        "categories"    => article.categories.collect { |c| c.name },
        "mt_text_more" 	=> article.extended,
        "mt_excerpt"    => article.excerpt,
        "mt_keywords"   => article.keywords,
        "mt_allow_comments" => article.allow_comments.to_i,
        "mt_allow_pings"    => article.allow_pings.to_i,
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
