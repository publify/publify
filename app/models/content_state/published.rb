module ContentState
  class Published < Base
    include Reloadable
    include Singleton

    def published?
      true
    end

    def enter_hook(content)
      super
      content[:published] = true
      content[:published_at] ||= Time.now
    end

    def change_published_state(content, boolean)
      content[:published] = boolean
      if ! content.published
        content[:published_at] = nil
        content.state = Withdrawn.instance
      end
    end

    def set_published_at(content, new_time)
      content[:published_at] = new_time
      return if content.published_at.nil?
      if content.published_at > Time.now
        content.state = JustPublished.instance
      end
    end
  end
end
