module ContentState
  class Spam < Base
    include Reloadable
    include Singleton

    def enter_hook(content)
      super
      content[:published] = false
    end

    def is_spam?(content)
      true
    end

    def to_s
      'Spam'
    end

    def mark_as_spam(content)

    end
  end
end
