module ContentState
  class JustMarkedAsHam < JustPresumedHam
    include Singleton

    def enter_hook(content)
      super
      content[:status_confirmed] = true
    end

    def memento
      'ContentState::Ham'
    end

    def just_changed_published_status?
      true
    end
  end
end
