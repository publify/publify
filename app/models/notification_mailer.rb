class NotificationMailer < ActionMailer::Base 
  helper :mail
   
  def article(controller, article, user)
    setup(controller, user)
    @subject        = "[#{config[:blog_name]}] New article: #{article.title}"
    @body[:article] = article
  end

  def comment(controller, comment, user)
    setup(controller, user)
    @subject        = "[#{config[:blog_name]}] New comment on #{comment.article.title}"
    @body[:article] = comment.article
    @body[:comment] = comment
  end

  def trackback(sent_at = Time.now)
    setup(user)
    @subject          = "[#{config[:blog_name]}] New trackback on #{trackback.article.title}"
    @body[:article]   = trackback.article
    @body[:trackback] = trackback
  end
  
  private
  def setup(controller, user)
    @body[:user] = user
    @body[:controller] = controller
    @recipients  = user.email
    @from        = config[:email_from]
    @headers     = {'X-Mailer' => "Typo #{TYPO_VERSION}"}
  end
  
end
