class EmailNotifier < ActiveRecord::Observer
  observe Article, Comment

  def after_save(content)
    content.send_notifications
    true
  end
end
