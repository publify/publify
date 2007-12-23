module Admin::FeedbackHelper
  def link_to_article_edit(article)
    link_to truncate(article.title, 60), :controller => '/admin/content', :action => 'edit', :id => article.id
  end

  def task_showmod(title, action, current=nil)
    content_tag :li,
      link_to(title, {:published => (action =~ /spam/ ? 'f' : ''),
                     :confirmed => (action =~ /unconfirmed/ ? 'f' : ''),
                     :search => params[:search]},
             :class => current)
  end
  
  def count_spam
    _('Limit to spam') + " (" + Feedback.count(:all, :conditions => "state = 'spam'").to_s + ")"
  end
  
  def count_unconfirmed
    _("Limit to unconfirmed") + " (" + Feedback.count(:all, :conditions => "state in ('presumed_ham', 'presumed_spam')").to_s + ")"
  end
  
  def count_unconfirmed_spam 
    _('Limit to unconfirmed spam') + " (" + Feedback.count(:all, :conditions => "state = 'presumed_spam'").to_s + ")"
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
