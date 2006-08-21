module ContentState
  class PresumedSpam < Base
    include Singleton

    def enter_hook(content)
      super
      content[:published] = false
      content[:status_confirmed] = false
    end

    def is_spam?(content)
      true
    end

    def mark_as_ham(content)
      content.state = Factory.new(:just_marked_as_ham)
    end

    def mark_as_spam(content)
      content.state = Factory.new(:spam)
    end

    def withdraw(content)
      content.mark_as_spam
    end

    def confirm_classification(content)
      content.mark_as_spam
    end

    def to_s
      "Spam?"
    end
  end
end
