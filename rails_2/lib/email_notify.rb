class EmailNotify
  def self.logger
    @@logger ||= RAILS_DEFAULT_LOGGER || Logger.new(STDOUT)
  end

  def self.send_comment(comment, user)
    return if user.email.blank?

    begin
      email = NotificationMailer.create_comment(comment, user)
      EmailNotify.send_message(user,email)
    rescue => err
      logger.error "Unable to send comment email: #{err.inspect}"
    end
  end

  def self.send_article(article, user)
    return if user.email.blank?

    begin
      email = NotificationMailer.create_article(article, user)
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
