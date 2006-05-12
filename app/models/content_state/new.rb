module ContentState
  class New < Base
    include Reloadable
    include Singleton
    class << self
      def derivable_from(content)
        content.new_record? &&
          !content.published &&
          content.published_at.nil?
      end
    end

    def serialize_on(content)
      content[:published] = false
      content[:published_at] = nil
      true
    end

    def before_save(content)
      super
      content.state = Draft.instance
    end

    def change_published_state(content, boolean)
      content[:published] = boolean
      if content.published
        content.state = JustPublished.instance
      end
    end

    def set_published_at(content, new_time)
      content[:published_at] = new_time
      return if new_time.nil?
      if new_time <= Time.now
        content.state = JustPublished.instance
      else
        content.state = PublicationPending.instance
      end
    end

    def draft?
      true
    end
  end
end
