module ContentState
  class Unclassified < Base
    include Singleton

    def enter_hook(content)
      super
      content[:published] = false
      content[:status_confirmed] = false
    end

    def published?(content)
      classify(content).published?(content)
    end

    def is_spam?(content)
      classify(content).is_spam?(content)
    end

    def classify(content)
      content.state = case content.classify
                      when :ham
                        Factory.new(:just_presumed_ham)
                      when :spam
                        Factory.new(:presumed_spam)
                      else
                        Factory.new(:presumed_spam)
                      end
    end

    def before_save(feedback)
      classify(feedback)
    end

    def to_s
      "Unclassified"
    end
  end
end
