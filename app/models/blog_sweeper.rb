class BlogSweeper < ActiveRecord::Observer
  observe Article, Comment

  def after_save(record)
    if record.is_a?(Comment)
      @article = record.article
    else
      @article = record
    end
  end

  def filter(controller)
    controller.expire_page :controller => "xml", :action => ["atom", "rss", "commentrss"]
    controller.expire_action :controller => "articles", :action => "index"        

    if @article
      controller.expire_page :controller => "articles", :action => "read", :id=> @article.id
    end
  end
end
