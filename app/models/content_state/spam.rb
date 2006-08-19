module ContentState
  class Spam < Base
    include Singleton

    def enter_hook(content)
      super
      content[:published] = false
      content[:status_confirmed] = true
    end

    def is_spam?(content)
      true
    end

    def status_confirmed?(content)
      true
    end

    def to_s
      'Spam'
    end

    def mark_as_spam(content)

    end
  end
end
