class MoveableTypeApi

  attr_reader :request

  def initialize(request)
    @request = request
  end

  def getRecentPostTitles(blogid, username, password, numberOfPosts)
    raise "Invalid login" unless valid_login?(username, password)
    
    array = []
    articles = Article.find_all(nil,"created_at DESC", numberOfPosts)
    articles.each do |article|
      array << {"dateCreated"   => article.created_at,
                "userid"        => blogid.to_s,
                "postid"        => article.id.to_s,
                "title"         => article.title
               } 
    end
    array
  end

  def getCategoryList(blogid, username, password)
    raise "Invalid login" unless valid_login?(username, password)

    categories = Array.new
    Category.find_all.each do |c| 
      categories << {"categoryId"   => c.id,
                     "categoryName" => c.name
                    } 
    end
    categories
  end

  def getPostCategories(postid, username, password)
    raise "Invalid login" unless valid_login?(username, password)

    article = Article.find(postid)
    categories = Array.new
    article.categories.each do |c|
      categories << {"categoryName" => c.name,
                     "categoryId"   => c.id,
                     "isPrimary"    => c.is_primary
                    }
    end
    categories
  end

  def setPostCategories(postid, username, password, categories)
    raise "Invalid login" unless valid_login?(username, password)
    
    article = Article.find(postid)
    
    if categories != nil
      article.categories.clear
      categories.each do |c|
        category = Category.find(c['categoryId'])
        article.categories.push_with_attributes(category, :is_primary => c['isPrimary'])
      end
    end
    article.save
  end

  # Wow, this should really do something.
  # It's a little vague in the spec though.
  def supportedMethods()
  end

  #  No per post text filtering currently, maybe later.
  def supportedTextFilters()
    []
  end

  def getTrackbackPings(postid)
    article = Article.find(postid)
    tb = Array.new
    article.trackbacks.each do |t|
      tb << {'pingTitle' => t.title,
             'pingURL'   => t.url,
             'pingIP'    => t.ip}
    end
    tb
  end

  def publishPost(postid, username, password)
    raise "Invalid login" unless valid_login?(username, password)
    article = Article.find(postid)
    article.published = 1
    article.save    
  end

  private

  def valid_login?(user,pass)
    user == config['login'] && pass == config['password']
  end

  def pub_date(time)
    time.strftime "%a, %e %b %Y %H:%M:%S %Z"
  end

end
