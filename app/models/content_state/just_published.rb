module ContentState
  class JustPublished < Published
    include Reloadable
    include Singleton

    class << self
      def derivable_from(content)
        content.new_record? &&
          content.published &&
          content.published_at.nil?
      end
    end

    def just_published?
      true
    end


    def serialize_on(content)
      content[:published] = true
      content[:published_at] ||= Time.now
      true
    end

    def set_published_at(content, new_time)
      content[:published_at] = new_time
      return if content.published_at.nil?
      if content.published_at > Time.now
        content.state = PublicationPending.instance
      end
    end

    def after_save(content)
      content.state = Published.instance
    end

    def send_notifications(content)
      blog       = content.blog
      controller = blog.controller
      User.find_boolean(:all, :notify_on_new_articles).each do |u|
        if u.notify_via_email?
          EmailNotify.send_article(controller, content, u)
        end

        if u.notify_via_jabber?
          JabberNotify.send_message(u, "New post",
                                    "A new message was posted to #{blog.blog_name}",
                                    content.body_html)
        end
      end
    end
  end
end
