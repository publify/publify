module ContentState
  class PresumedHam < Base
    include Reloadable
    include Singleton

    def enter_hook(content)
      super
      content[:published] = true
      content[:status_confirmed] = false
    end

    def published?(content)
      true
    end

    def withdraw(content)
      content.mark_as_spam
    end

    def confirm_classification(content)
      content.mark_as_ham
    end

    def to_s
      'Ham?'
    end
  end
end
