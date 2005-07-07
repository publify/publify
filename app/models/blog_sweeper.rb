class BlogSweeper < ActiveRecord::Sweeper
  observe Article, Comment, Trackback

  def after_save(record)
    case record
    when Comment, Trackback:
      expire_page :controller => "/xml", :action => ["commentrss"]
      expire_page :controller => "/xml", :action => ["articlerss"], :id => record.article.id
    when Article
      expire_page :controller => "/xml", :action => ["atom", "rss"]
    end
  end
end
