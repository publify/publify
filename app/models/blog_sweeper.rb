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
    if @article
      controller.expire_page :controller => "xml", :action => ["atom", "rss", "commentrss"]
    end
  end
end
