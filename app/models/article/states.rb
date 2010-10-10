module Article::States
  class Base < Stateful::State
    alias_method :content, :model

    def to_s
      self.class.to_s.demodulize
    end

    def exit_hook(target)
      ::Rails.logger.debug("#{content} leaving state #{self.class}")
    end

    def enter_hook
      ::Rails.logger.debug("#{content} entering state #{self.class}")
    end

    def post_trigger; true; end
    def send_notifications; true; end
    def send_pings; true; end

    def withdraw
    end
  end

  class New < Base
    def enter_hook
      super
      content[:published] = false
      content[:published_at] = nil
    end

    def published=(boolean)
      if boolean
        content.state = :just_published
      end
      return boolean
    end

    def published_at=(new_time)
      new_time = (new_time.to_time rescue nil)
      unless new_time.nil?
        content.state = (new_time <= Time.new) ? :just_published : :publication_pending
      end
      content[:published_at] = new_time
    end

    def draft?
      true
    end
  end

  class JustPublished < Base
    def enter_hook
      super
      content.just_changed_published_status = true
      content.state = :published
    end
  end


  class Published < Base
    def enter_hook
      super
      content[:published] = true
      content[:published_at] ||= Time.now
    end

    def published=(boolean)
      if !boolean
        content.state = :just_withdrawn
      end
    end

    def withdraw
      content.state = :just_withdrawn
    end

    def published_at=(new_time)
      new_time = (new_time.to_time rescue nil)
      return if new_time.nil?
      content[:published_at] = new_time
      if new_time > Time.now
        content.state = :publication_pending
      end
    end

    def send_notifications
      content.really_send_notifications if just_published?
      true
    end

    def send_pings
      content.really_send_pings if just_published?
      true
    end

    def just_published?
      content.just_changed_published_status?
    end
  end

  class JustWithdrawn < Base
    def enter_hook
      super
      content.just_changed_published_status = true
      content.state = :withdrawn
    end
  end

  class Withdrawn < Base
    def enter_hook
      content[:published] = false
    end

    def published=(boolean)
      return unless boolean
      content.state = :published
    end

    def published_at=(new_time)
      new_time = (new_time.to_time rescue nil)
      content[:published_at] = new_time
      Trigger.remove(content, :trigger_method => 'publish!')
      return if new_time.nil? || new_time <= Time.now
      content.state = :publication_pending
    end
  end

  class PublicationPending < Base
    def enter_hook
      content[:published] = false if content.new_record?
    end

    def published=(published)
      content[:published] = published

      if published && content.published_at <= Time.now
        content.state = :just_published
      end
    end

    def published_at=(new_time)
      new_time = (new_time.to_time rescue nil)
      content[:published_at] = new_time
      Trigger.remove(content, :trigger_method => 'publish!')
      if new_time.nil?
        content.state = :draft
      elsif new_time <= Time.now
        content.state = :just_published
      end
    end

    def post_trigger
      Trigger.post_action(content.published_at, content, 'publish!')
    end

    def withdraw(content)
      content.state = :draft
    end
  end

  class Draft < Base
    def enter_hook
      super
      content[:published] = false
      content[:published_at] = nil
    end

    def published=(boolean)
      if boolean
        content.state = :just_published
      end
    end

    def published_at=(new_time)
      # Because of the workings of the controller, we should ignore
      # publication times before the current time.
      new_time = (new_time.to_time rescue nil)
      return if new_time.nil? || new_time <= Time.now
      content[:published_at] = new_time
      content.state = :publication_pending
    end
  end
end
