module ContentState
  class Base
    include Reloadable

    class << self
      def instance
        nil
      end

      protected :new
    end

    def before_save(content)
      serialize_on(content)
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
  end
end

