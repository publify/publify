module Admin::FeedbackHelper
  def link_to_article_edit(article)
    link_to truncate(article.title, 60), :controller => 'content', :action => 'edit', :id => article.id
  end
  
  def task_showmod(title)
    content_tag :li, link_to(title, :published => 'f', :search => params[:search])
  end  
end
