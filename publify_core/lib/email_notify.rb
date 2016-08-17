# TODO: Use deliver_later to avoid slowness and errors
class EmailNotify
  def self.logger
    @@logger ||= ::Rails.logger || Logger.new(STDOUT)
  end

  def self.send_comment(comment, user)
    return if user.email.blank?

    email = NotificationMailer.comment(comment, user)
    email.deliver_now
  end

  def self.send_article(article, user)
    return if user.email.blank?

    email = NotificationMailer.article(article, user)
    email.deliver_now
  end

  # Send a welcome mail to the user created
  def self.send_user_create_notification(user)
    email = NotificationMailer.notif_user(user)
    email.deliver_now
  end
end
