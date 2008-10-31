module Admin::FeedbackHelper
  def link_to_article_edit(article)
    link_to truncate(article.title, :length => 60), :controller => '/admin/content', :action => 'edit', :id => article.id
  end

end
