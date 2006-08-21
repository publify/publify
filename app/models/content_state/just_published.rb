module ContentState
  class JustPublished < Published
    include Singleton

    # We need to save the state as 'Published', but we need after_save
    # to be handled by JustPublished. So, JustPublished tells Rails that
    # it's *actually* Published and all shall be well.
    def memento
      'ContentState::Published'
    end

    def just_published?
      true
    end

    def just_changed_published_status?
      true
    end

    def published?(content)
      true
    end

    def enter_hook(content)
      super
      content[:published] = true
      content[:published_at] ||= Time.now
    end

    def set_published_at(content, new_time)
      content[:published_at] = new_time
      return if content[:published_at].nil?
      if content.published_at > Time.now
        content.state = PublicationPending.instance
      end
    end

    def send_notifications(content)
      content.interested_users.each do |user|
        content.send_notification_to_user(user)
      end
    end

    def send_pings(content)
      content.really_send_pings
    end

    def withdraw(content)
      content[:published_at] = nil
      content.state = Factory.new(:draft)
    end
  end
end
