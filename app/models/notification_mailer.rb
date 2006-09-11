class NotificationMailer < ActionMailer::Base
  helper :mail
  
  def article(article, user)
    setup(user, article)
    @subject        = "[#{article.blog.blog_name}] New article: #{article.title}"
    @body[:article] = article
  end

  def comment(comment, user)
    setup(user, comment)
    @subject        = "[#{comment.blog.blog_name}] New comment on #{comment.article.title}"
    @body[:article] = comment.article
    @body[:comment] = comment
  end

  def trackback(sent_at = Time.now)
    setup(user, trackback)
    @subject          = "[#{trackback.blog.blog_name}] New trackback on #{trackback.article.title}"
    @body[:article]   = trackback.article
    @body[:trackback] = trackback
  end

  private
  def setup(user, content)
    @body[:user] = user
    @body[:blog] = content.blog
    @recipients  = user.email
    @from        = content.blog.email_from
    @headers     = {'X-Mailer' => "Typo #{TYPO_VERSION}"}
    @blog_name   = content.blog.blog_name
  end

end
