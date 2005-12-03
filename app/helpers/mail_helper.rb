module MailHelper
  def article_url(controller, article, only_path = true, anchor = nil)
    controller.url_for :controller=>"/articles", :action =>"permalink", :year => article.created_at.year, :month => sprintf("%.2d", article.created_at.month), :day => sprintf("%.2d", article.created_at.day), :title => article.permalink, :anchor => anchor
  end
end

