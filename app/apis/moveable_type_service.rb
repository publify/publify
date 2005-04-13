module MoveableTypeStructs
  class ArticleTitle < ActionWebService::Struct
    member :dateCreated,  :datetime
    member :userid,       :int
    member :postid,       :int
    member :title,        :string
  end

  class CategoryList < ActionWebService::Struct
    member :categoryId,   :int
    member :categoryName, :string
  end

  class CategoryPerPost < ActionWebService::Struct
    member :categoryName, :string
    member :categoryId,   :int
    member :isPrimary,    :int
  end

  class TextFilter < ActionWebService::Struct
    member :key,    :string
    member :label,  :string
  end

  class TrackBack < ActionWebService::Struct
    member :pingTitle,  :string
    member :pingURL,    :string
    member :pingIP,     :string
  end
end


class MoveableTypeApi < ActionWebService::API::Base
  inflect_names false

  api_method :getCategoryList,
    :expects => [ {:blogid => :int}, {:username => :string}, {:password => :string} ],
    :returns => [[MoveableTypeStructs::CategoryList]]

  api_method :getPostCategories,
    :expects => [ {:postid => :int}, {:username => :string}, {:password => :string} ],
    :returns => [[MoveableTypeStructs::CategoryPerPost]]

  api_method :getRecentPostTitles,
    :expects => [ {:blogid => :int}, {:username => :string}, {:password => :string}, {:numberOfPosts => :int} ],
    :returns => [[MoveableTypeStructs::ArticleTitle]]

  api_method :setPostCategories,
    :expects => [ {:postid => :int}, {:username => :string}, {:password => :string}, {:categories => [MoveableTypeStructs::CategoryPerPost]} ],
    :returns => [:bool]

  api_method :supportedTextFilters,
    :returns => [[MoveableTypeStructs::TextFilter]]

  api_method :getTrackbackPings,
    :expects => [ {:postid => :int}],
    :returns => [[MoveableTypeStructs::TrackBack]]

  api_method :publishPost,
    :expects => [ {:postid => :int}, {:username => :string}, {:password => :string} ],
    :returns => [:bool]
end


class MoveableTypeService < TypoWebService
  web_service_api MoveableTypeApi
  
  before_invocation :authenticate, :except => [:getTrackbackPings, :supportedMethods, :supportedTextFilters]

  def getRecentPostTitles(blogid, username, password, numberOfPosts)
    Article.find_all(nil,"created_at DESC", numberOfPosts).collect do |article|
      MoveableTypeStructs::ArticleTitle.new(
            :dateCreated => article.created_at,
            :userid      => blogid.to_s,
            :postid      => article.id.to_s,
            :title       => article.title
          )      
    end
  end

  def getCategoryList(blogid, username, password)
    Category.find_all.collect do |c| 
      MoveableTypeStructs::CategoryList.new(
          :categoryId   => c.id,
          :categoryName => c.name
        )
    end
  end

  def getPostCategories(postid, username, password)
    Article.find(postid).categories.collect do |c|
      MoveableTypeStructs::CategoryPerPost.new(
          :categoryName => c.name,
          :categoryId   => c.id.to_i,
          :isPrimary    => c.is_primary.to_i
        )
    end
  end

  def setPostCategories(postid, username, password, categories)
    article = Article.find(postid)
    article.categories.clear if categories != nil

    for c in categories
      category = Category.find(c['categoryId'])
      article.categories.push_with_attributes(category, :is_primary => c['isPrimary'])
    end
    
    article.save
  end

  # Wow, this should really do something.
  # It's a little vague in the spec though.
  def supportedMethods()
  end

  # Support for markdown and textile formatting dependant on the relevant 
  # translators being available.
  def supportedTextFilters()
    filters = []
    begin
      BlueCloth.new("test")
      filters << MoveableTypeStructs::TextFilter.new(:key => 'markdown', :label => 'Markdown')
    rescue
    end
    begin
      RedCloth.new("test")
      filters << MoveableTypeStructs::TextFilter.new(:key => 'textile', :label => 'Textile')
    rescue
    end
    filters
  end

  def getTrackbackPings(postid)
    article = Article.find(postid)
    article.trackbacks.collect do |t|
      MoveableTypeStructs::TrackBack.new(
          :pingTitle  => t.title.to_s,
          :pingURL    => t.url.to_s,
          :pingIP     => t.ip.to_s
        )
    end
  end

  def publishPost(postid, username, password)
    article = Article.find(postid)
    article.published = 1
    article.save    
  end

  private

  def pub_date(time)
    time.strftime "%a, %e %b %Y %H:%M:%S %Z"
  end
end