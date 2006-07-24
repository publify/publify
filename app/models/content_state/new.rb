module ContentState
  class New < Base
    include Reloadable
    include Singleton

    def enter_hook(content)
      super
      content[:published] = false
      content[:published_at] = nil
    end

    def before_save(content)
      super
      content.state = Draft.instance
    end

    def change_published_state(content, boolean)
      content[:published] = boolean
      if boolean
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
