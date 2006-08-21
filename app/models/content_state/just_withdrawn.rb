module ContentState
  class JustWithdrawn < Withdrawn
    def memento
      'ContentState::Withdrawn'
    end

    def just_changed_published_status?
      true
    end
  end
end
