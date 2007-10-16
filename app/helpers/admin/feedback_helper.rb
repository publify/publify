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
  
  def count_spam
    _('Limit to spam') + " (" + Feedback.count(:all, :conditions => "state = 'spam'").to_s + ")"
  end
  
  def count_unconfirmed
    _("Limit to unconfirmed") + " (" + Feedback.count(:all, :conditions => "state in ('presumed_ham', 'presumed_spam')").to_s + ")"
  end
  
  def count_unconfirmed_spam 
    _('Limit to unconfirmed spam') + " (" + Feedback.count(:all, :conditions => "state = 'presumed_spam'").to_s + ")"
  end
end
