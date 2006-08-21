module ContentState
  class StateError < StandardError
  end

  class StateNotSerializable < StateError
  end

  class Base
    class << self
      def instance
        nil
      end

      protected :new
    end

    def memento
      self.class.to_s
    end

    def exit_hook(content, target_state)
      logger.debug("#{content} leaving state #{self.memento}")
    end

    def enter_hook(content)
      logger.debug("#{content} entering state #{self.memento}")
    end

    def before_save(content)
      true
    end

    def after_save(content)
      true
    end

    def withdraw(content)
    end

    def mark_as_spam(content)
      content.state = Factory.new(:just_marked_as_spam)
    end

    def mark_as_ham(content)
      content.state = Factory.new(:just_marked_as_ham)
    end

    def published?(content)
      false
    end

    def just_published?
      false
    end

    def just_changed_published_status?
      false
    end

    def draft?
      false
    end

    def publication_pending?
      false
    end

    def withdrawn?
      false
    end

    def after_save(content)
      true
    end

    def post_trigger(content)
      true
    end

    def send_notifications(controller)
      true
    end

    def send_pings(content)
      true
    end

    def is_spam?(content)
      false
    end

    def status_confirmed?(content)
      false
    end

    def logger
      @logger ||= RAILS_DEFAULT_LOGGER || Logger.new(STDERR)
    end

    def confirm_classification(content)
    end
  end
end

