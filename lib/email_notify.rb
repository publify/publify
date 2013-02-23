class EmailNotify
  def self.logger
    @@logger ||= ::Rails.logger || Logger.new(STDOUT)
  end

  def self.send_comment(comment, user)
    return if user.email.blank?

    begin
      email = NotificationMailer.comment(comment, user)
      email.deliver
    rescue => err
      logger.error "Unable to send comment email: #{err.inspect}"
    end
  end

  def self.send_article(article, user)
    return if user.email.blank?

    begin
      email = NotificationMailer.article(article, user)
      email.deliver
    rescue => err
      logger.error "Unable to send article email: #{err.inspect}"
    end
  end

  # Send a welcome mail to the user created
  def self.send_user_create_notification(user)
    begin
      email_notification = NotificationMailer.notif_user(user)
      email.deliver
    rescue => err
      logger.error "Unable to send notification of create user email: #{err.inspect}"
    end
  end
end
