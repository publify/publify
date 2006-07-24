module ContentState
  class Withdrawn < Base
    include Reloadable
    include Singleton
    
    def enter_hook(content)
      content[:published] = false
    end
    
    def change_published_state(content, boolean)
      return unless boolean
      content[:published] = true
      content.state = Published.instance
    end
    
    def set_published_at(content, new_time)
      content[:published_at] = new_time
      Trigger.remove(content, :trigger_method => 'publish!')
      return if new_time.nil? || new_time <= Time.now
      content.state = PublicationPending.instance
    end
    
    def withdrawn?
      true
    end
  end
end
      
