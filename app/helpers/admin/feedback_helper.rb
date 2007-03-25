module Admin::FeedbackHelper
  def link_to_article_edit(article)
    link_to truncate(article.title, 60), :controller => '/admin/content', :action => 'edit', :id => article.id
  end

  def task_showmod(title, action)
    content_tag :li,
      link_to(title, :published => (action =~ /spam/ ? 'f' : ''),
                     :confirmed => (action =~ /unconfirmed/ ? 'f' : ''),
                     :search => params[:search])
  end
end
