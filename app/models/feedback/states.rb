module Feedback::States
  class Base < Stateful::State
    # Give the default 'model' a more meaningful name
    alias_method :content, :model

    def before_save;           true; end
    def after_save;            true; end
    def after_initialize;      true; end
    def post_trigger;          true; end
    def send_notifications;    true; end
    def report_classification; true; end

    def withdraw;                    end
    def confirm_classification;      end

    def mark_as_spam
      content.state = :just_marked_as_spam
    end

    def mark_as_ham
      content.state = :just_marked_as_ham
    end
  end

  class Unclassified < Base
    def after_initialize
      returning(true) { enter_hook }
    end

    def enter_hook
      super
      content[:published] = false
      content[:status_confirmed] = false
    end

    def published?
      classify_content
      content.published?
    end

    def just_published?
      classify_content
      content.just_published?
    end

    def spam?
      classify_content;
      content.spam?
    end

    def classify_content
      content.state = case content.classify
                      when :ham;  :just_presumed_ham
                      when :spam; :presumed_spam
                      else        :presumed_spam
                      end
    end

    def before_save
      classify_content
    end
  end

  class JustPresumedHam < Base
    def enter_hook
      super
      content.just_changed_published_status = true
      content.state = :presumed_ham
    end
  end

  class PresumedHam < Base
    def enter_hook
      super
      content[:published] = true
      content[:status_confirmed] = false
    end

    def published?; true; end

    def just_published?
      content.just_changed_published_status?
    end

    def withdraw
      mark_as_spam
    end

    def confirm_classification
      mark_as_ham
    end

    def mark_as_ham
      content.state = :ham
    end

    def to_s
      "Ham?"
    end

    def send_notifications
      content.really_send_notifications if content.just_changed_published_status
      return true
    end
  end

  class JustMarkedAsHam < Base
    def enter_hook
      super
      content.just_changed_published_status = true
      content.state = :ham
    end
  end

  class Ham < Base
    def enter_hook
      super
      content[:published] = true
      content[:status_confirmed] = true
    end

    def published?;        true; end
    def status_confirmed?; true; end

    def mark_as_ham;             end

    def just_published?
      content.just_changed_published_status?
    end

    def withdraw
      mark_as_spam
    end

    def report_classification
      content.report_as_ham if content.just_changed_published_status?
      true
    end

    def send_notifications
      content.really_send_notifications if content.just_changed_published_status?
      true
    end
  end

  class PresumedSpam < Base
    def enter_hook
      super
      content[:published] = false
      content[:status_confirmed?] = false
    end

    def spam?; true; end

    def mark_as_ham
      content.state = :just_marked_as_ham
    end

    def mark_as_spam
      content.state = :spam
    end

    def withdraw
      mark_as_spam
    end

    def confirm_classification
      mark_as_spam
    end

    def to_s
      "Spam?"
    end
  end

  class JustMarkedAsSpam < Base
    def enter_hook
      super
      content.just_changed_published_status = true
      content.state = :spam
    end
  end

  class Spam < Base
    def enter_hook
      super
      content[:published] = false
      content[:status_confirmed] = true
    end

    def spam?;             true; end
    def status_confirmed?; true; end

    def mark_as_spam;            end

    def report_classification
      content.report_as_spam if content.just_changed_published_status?
      true
    end
  end
end
