class Comment < Content
  include TypoGuid

  content_fields :body
  
  belongs_to :article, :counter_cache => true
  belongs_to :user

  validates_presence_of :author, :body
  validates_against_spamdb :body, :url, :ip
  validates_age_of :article_id
 
  def send_notification_to_user(controller, user)
    #if user.notify_on_comments?
      if user.notify_via_email? 
        EmailNotify.send_comment(controller, self, user)
      end

      if user.notify_via_jabber?
        JabberNotify.send_message(user, "New comment", "A new comment was posted to '#{article.title}' on #{config[:blog_name]} by #{author}: #{body}", self.body_html)
      end
    #end
  end
  
  def send_notifications(controller)
    users = User.find_boolean(:all, :notify_on_comments)
    self.notify_users = users
    users.each do |u|
      send_notification_to_user(controller,u)
    end
  end
 
  protected
  
  def body_html_postprocess(value, controller)
    controller.send(:sanitize, controller.send(:auto_link, value))
  end

  def default_text_filter_config_key
    'comment_text_filter'
  end
  
  before_create :create_guid
  before_save :correct_url, :make_nofollow
    
  def correct_url
    unless url.to_s.empty?
      unless url =~ /^http\:\/\//
        self.url = "http://#{url}"
      end
    end
  end

  def make_nofollow
    self.author    = author.nofollowify
    self.body_html = body_html.to_s.nofollowify
  end
end
