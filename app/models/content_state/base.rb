module ContentState
  class Base
    include Reloadable

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

    def published?
      false
    end

    def just_published?
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

    def send_notifications(content)
      true
    end

    def send_pings(content)
      true
    end

    def logger
      @logger ||= RAILS_DEFAULT_LOGGER || Logger.new(STDERR)
    end
  end
end

