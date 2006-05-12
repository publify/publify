module ContentState
  class PublicationPending < Base
    include Reloadable
    include Singleton
    class << self
      def derivable_from(content)
        !content.published && content.published_at ||
          content.new_record? && content.published_at &&
          content.published_at > Time.now
      end
    end

    def serialize_on(content)
      content[:published] = false if content.new_record?
      true
    end

    def change_published_state(content, boolean)
      content[:published] = boolean
      if content.published && content.published_at <= Time.now
        content.state = JustPublished.instance
      end
    end

    def set_published_at(content, new_time)
      content[:published_at] = new_time
      Trigger.remove(content, :trigger_method => 'publish!')
      if new_time.nil?
        content.state = Draft.instance
      elsif new_time <= Time.now
        content.state = JustPublished.instance
      end
    end

    def publication_pending?
      true
    end

    def post_trigger(content)
      Trigger.post_action(content.published_at, content, 'publish!')
    end
  end
end
