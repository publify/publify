module ContentState
  class JustPublished < Published
    include Reloadable
    include Singleton

    class << self
      def derivable_from(content)
        content.new_record? &&
          content.published &&
          content[:published_at].nil?
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
      return if content[:published_at].nil?
      if content.published_at > Time.now
        content.state = PublicationPending.instance
      end
    end

    def after_save(content)
      content.state = Published.instance
    end

    def send_notifications(content, controller)
      content.interested_users.each do |user|
        content.send_notification_to_user(controller, user)
      end
    end

    def send_pings(content)
      content.really_send_pings
    end
  end
end
