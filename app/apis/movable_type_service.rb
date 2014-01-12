module MovableTypeStructs
  class ArticleTitle < ActionWebService::Struct
    member :dateCreated,  :time
    member :userid,       :string
    member :postid,       :string
    member :title,        :string
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


class MovableTypeApi < ActionWebService::API::Base
  api_method :getRecentPostTitles,
    :expects => [ {:blogid => :string}, {:username => :string}, {:password => :string}, {:numberOfPosts => :int} ],
    :returns => [[MovableTypeStructs::ArticleTitle]]

  api_method :supportedMethods,
    :expects => [],
    :returns => [[:string]]

  api_method :supportedTextFilters,
    :expects => [],
    :returns => [[MovableTypeStructs::TextFilter]]

  api_method :getTrackbackPings,
    :expects => [ {:postid => :string}],
    :returns => [[MovableTypeStructs::TrackBack]]

  api_method :publishPost,
    :expects => [ {:postid => :string}, {:username => :string}, {:password => :string} ],
    :returns => [:bool]
end


class MovableTypeService < PublifyWebService
  web_service_api MovableTypeApi

  before_invocation :authenticate, :except => [:getTrackbackPings, :supportedMethods, :supportedTextFilters]

  def getRecentPostTitles(blogid, username, password, numberOfPosts)
    Article.find(:all,:order => "created_at DESC", :limit => numberOfPosts).collect do |article|
      MovableTypeStructs::ArticleTitle.new(
            :dateCreated => article.created_at,
            :userid      => blogid.to_s,
            :postid      => article.id.to_s,
            :title       => article.title
          )
    end
  end

  def supportedMethods()
    MovableTypeApi.api_methods.keys.collect { |method| method.to_s }
  end

  # Support for markdown and textile formatting dependant on the relevant
  # translators being available.
  def supportedTextFilters()
    TextFilter.find(:all).collect do |filter|
      MovableTypeStructs::TextFilter.new(:key => filter.name, :label => filter.description)
    end
  end

  def getTrackbackPings(postid)
    article = Article.find(postid)
    article.trackbacks.collect do |t|
      MovableTypeStructs::TrackBack.new(
          :pingTitle  => t.title.to_s,
          :pingURL    => t.url.to_s,
          :pingIP     => t.ip.to_s
        )
    end
  end

  def publishPost(postid, username, password)
    article = Article.find(postid)
    article.published = true
    article.save
  end
end
