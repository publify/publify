module ContentState
  class Draft < Base
    include Singleton

    def enter_hook(content)
      super
      content[:published] = false
      content.published_at = nil
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
        content[:published_at] = nil
      else
        content.state = PublicationPending.instance
      end
    end

    def draft?
      true
    end
  end
end
