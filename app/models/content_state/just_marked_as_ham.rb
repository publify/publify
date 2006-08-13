module ContentState
  class JustMarkedAsHam < JustPresumedHam
    include Reloadable
    include Singleton

    def enter_hook(content)
      super
      content[:status_confirmed] = true
    end

    def memento
      'ContentState::Ham'
    end
  end
end
