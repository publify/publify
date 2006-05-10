class EmailNotifier < ActiveRecord::Observer
  observe Article, Comment

  def after_save(content)
    return true unless content.just_published?
    content.send_notifications
    true
  end
end
