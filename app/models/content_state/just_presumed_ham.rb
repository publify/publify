module ContentState
  class JustPresumedHam < PresumedHam
    include Singleton

    def memento
      'ContentState::PresumedHam'
    end

    def enter_hook(content)
      logger.debug("#{content} entering state Content::JustPresumedHam")
      content[:published] = true
      content[:status_confirmed] = false
    end

    def exit_hook(content, target_state)
      logger.debug("#{content} leaving state Content::JustPresumedHam")
    end

    def just_published?
      true
    end

    def just_changed_published_status?
      true
    end

    def send_notifications(content)
      content.interested_users.each do |user|
        content.send_notification_to_user(user)
      end
    end

    def send_pings(content)
      content.really_send_pings
    end
  end
end
