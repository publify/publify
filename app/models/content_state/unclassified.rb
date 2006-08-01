module ContentState
  class Unclassified < Base
    include Reloadable
    include Singleton

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

    def before_save(content)
      classify(content).before_save(content)
    end
  end
end
