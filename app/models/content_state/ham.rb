module ContentState
  class Ham < Base
    include Reloadable
    include Singleton

    def enter_hook(content)
      super
      content[:published] = true
    end

    def published?(content)
      true
    end

    def before_save(content)
      content.report_as_ham
      true
    end

    def withdraw(content)
      content.mark_as_spam
    end

    def to_s
      'Ham'
    end

    def mark_as_ham(content)
    end
  end
end
