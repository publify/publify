class MetaWeblogApi
  
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def newPost(blogid, username, password, struct, publish)
    raise "Invalid login" unless valid_login?(username, password)

    article = Article.new 
    article.body        = struct['description'] || ''
    category_commands, newtitle   = split_title(struct['title'])
    article.title       = newtitle || ''
    article.published   = publish ? 1 : 0
    article.author      = username
    # article.dateCreated

    # Moveable Type API support
    article.allow_comments = struct['mt_allow_comments'] || $config['default_allow_comments']
    article.allow_pings    = struct['mt_allow_pings'] || $config['default_allow_pings']
    #                      = struct['mt_convert_breaks']
    article.extended       = struct['mt_text_more'] || ''
    article.excerpt        = struct['mt_excerpt'] || ''
    article.keywords       = struct['mt_keywords'] || ''

    # Build new categories from the keywords
    # I'll probably push most of this code to category model
    # so that it can handle category "commands" on its own. (all assuming we stick with this)
    new_categories = []
    if category_commands != nil
      category_commands.each do |cc|
        case cc.sub(/^(.).*$/, "\\1")
          when "+"
            c = Category.new
            c.name = cc.sub(/^.(.*)$/, "\\1")
            c.save
            article.categories << c
          when "-"
            c = Category.find_by_name(cc.sub(/^.(.*)$/, "\\1"))
            c.destroy
          else
            # Users should only be using the + and - commands.  Do nothing.
        end
      end
    end
    
    if struct.has_key?('categories')
      new_categories += struct['categories']
      article.categories.clear
      Category.find_all.each do |c|
        article.categories << c if new_categories.include?(c.name)
      end
    end
    
    article.send_pings("#{server_url}/articles/read/#{article.id}", struct['mt_tb_ping_urls'])
    
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
    category_commands, newtitle   = split_title(struct['title'])
    article.title       = newtitle || ''
    article.published   = publish ? 1 : 0
    article.author      = username
    # article.dateCreated

    # Moveable Type API support
    article.allow_comments = struct['mt_allow_comments'] || $config['default_allow_comments']
    article.allow_pings    = struct['mt_allow_pings'] || $config['default_allow_pings']
    #                      = struct['mt_convert_breaks']
    article.extended       = struct['mt_text_more'] || ''
    article.excerpt        = struct['mt_excerpt'] || ''
    article.keywords       = struct['mt_keywords'] || ''

    # Build new categories from the keywords
    # I'll probably push most of this code to the category model
    # so that it can handle category "commands" on its own.
    new_categories = []
    if category_commands != nil
      category_commands.each do |cc|
        case cc.sub(/^(.).*$/, "\\1")
          when "+"
            c = Category.new
            c.name = cc.sub(/^.(.*)$/, "\\1")
            c.save
            article.categories << c
          when "-"
            c = Category.find_by_name(cc.sub(/^.(.*)$/, "\\1"))
            c.destroy
          else
            # Users should only be using the + and - commands.  Do nothing.
        end
      end
    end
    
    if struct.has_key?('categories')
      new_categories += struct['categories']
      article.categories.clear
      Category.find_all.each do |c|
        article.categories << c if new_categories.include?(c.name)
      end
    end

    article.send_pings("#{server_url}/articles/read/#{article.id}", struct['mt_tb_ping_urls'])

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
  
    articles.to_a.collect{ |c| item_from(c) }
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
    user == $config['login'] && pass == $config['password']
  end
  
  def pub_date(time)
    time.strftime "%a, %e %b %Y %H:%M:%S %Z"
  end
  
  def server_url
     "http://" << request.host << request.port_string 
  end

  # for splitting the category commands out of the title.. ugly, but workable (seth)
  def split_title(title)
    if title =~ /^\[(.*?)\].*/
      ary = title.scan(/^\[(.*?)\]\s*(.*)$/)
      # return a 2 element array, first element is array of category commands
      #                           second element is title
      [ ary[0][0].split(/\s+/), ary[0][1] ]
    else
      [nil, title]
    end
  end
   
end