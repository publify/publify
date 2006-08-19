module ContentState
  class Ham < Base
    include Singleton

    def enter_hook(content)
      super
      content[:published]        = true
      content[:status_confirmed] = true
    end

    def published?(content)
      true
    end

    def status_confirmed?(content)
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
