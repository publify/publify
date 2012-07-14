class NotificationMailer < ActionMailer::Base
  helper :mail
  layout nil

  def article(article, user)
    setup user, article.blog
    @article = article
    make_subject "New article: #{@article.title}"
    build_mail
  end

  def comment(comment, user)
    setup user, comment.blog
    @article = comment.article
    make_subject "New comment on #{@article.title}"
    @comment = comment
    build_mail
  end

  def trackback(sent_at = Time.now)
    setup user, trackback.blog
    @article = trackback.article
    make_subject "New trackback on #{@article.title}"
    @trackback = trackback
    build_mail
  end

  def notif_user(user)
    setup user, Blog.default
    build_mail
  end

  private

  def setup user, blog
    @user = user
    @blog = blog
    @recipients = user.email
    @from = blog.email_from
    headers['X-Mailer'] = "Typo #{TYPO_VERSION}"
  end

  def make_subject subject
    @subject = "[#{@blog.blog_name} #{subject}"
  end

  def build_mail
    mail(from: @from,
         to: @recipients,
         subject: @subject)
  end
end
