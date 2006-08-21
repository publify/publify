module ContentState
  class JustMarkedAsSpam < Spam
    def enter_hook(content)
      logger.debug("#{content} entering state Content::JustMarkedAsSpam")
      content[:published] = false
      content[:status_confirmed] = true
    end

    def exit_hook(content, target_state)
      logger.debug("#{content} leaving state Content::JustMarkedAsSpam")
    end

    def memento
      'ContentState::Spam'
    end

    def after_save(content)
      super
      content.report_as_spam
      true
    end

    def just_changed_published_status?
      true
    end
  end
end
