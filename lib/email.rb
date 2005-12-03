class EmailNotify
  def self.send_comment(controller, comment, user)
    return if user.email.blank?

    begin
      email = NotificationMailer.create_comment(controller, comment, user)
      EmailNotify.send_message(user,email)
    rescue => err
      logger.error "Unable to send comment email: #{err.inspect}"
    end
  end
  
  def self.send_article(controller, article, user)
    return if user.email.blank?

    begin
      email = NotificationMailer.create_article(controller, article, user)
      EmailNotify.send_message(user,email)
    rescue => err
      logger.error "Unable to send article email: #{err.inspect}"
    end
  end
  
  def self.send_message(user, email)
    email.content_type = "text/html; charset=utf-8"
    NotificationMailer.deliver(email)
  end
end