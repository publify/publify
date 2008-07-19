module Admin::FeedbackHelper
  def link_to_article_edit(article)
    link_to truncate(article.title, 60), :controller => '/admin/content', :action => 'edit', :id => article.id
  end

  # Define if all_feedback is the current
  def all_feedback
    if params[:confirmed] != 'f' and params[:published] != 'f'
      return 'current'
    end
  end

  # Define if limit to spam is the current
  def limit_to_spam
    if params[:published] == 'f' and params[:confirmed] != 'f'
      return 'current'
    end
  end

  # Define if limit to unconfirmed is the current
  def limit_to_unconfirmed
    if params[:published] != 'f' and params[:confirmed] == 'f'
      return 'current'
    end
  end

  # Define if limit to unconfirmed spam is the current
  def limit_to_unconfirmed_spam
    if params[:published] == 'f' and params[:confirmed] == 'f'
      return 'current'
    end
  end
end
