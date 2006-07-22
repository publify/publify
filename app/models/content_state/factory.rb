module ContentState
  class Factory
    def self.new(state_name)
      return ContentState::New.instance unless state_name
      state_name = state_name.to_s.underscore
      unless state_name.rindex('/')
        state_name = 'content_state/' + state_name
      end
      require state_name
      state_name.camelize.constantize.instance
    end
  end
end
