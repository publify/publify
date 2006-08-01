module ContentState
  class JustMarkedAsHam < JustPresumedHam
    include Reloadable
    include Singleton

    def memento
      'ContentState::Ham'
    end
  end
end
