class WebNotifier < ActiveRecord::Observer
  observe Article

  def after_save(article)
    article.send_pings
  end
end
