module Publishable
  
  def self.append_features(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods    
    def publishable(options = {})
      configuration = { :default => 0, :protect => false }
      configuration.update(options) 
      
      class_eval <<-ENV    
        before_save :set_published
        
        def set_published
          self.published ||= #{configuration[:default]}
        end
      
      ENV
      
      if configuration[:protect]
  
        class_eval <<-ENV
          alias :destroy :destroy_final
          
          def destroy
            unpublish
          end
        ENV
        
      end
    end
    
    def publish
      update_attribute "published", 1  
    end
    
    def unpublish
      update_attribute "published", 0      
    end
  
    def find_all_published(condition = nil, order = nil, limit = nil)
      sql =  "published != 0 "
      sql << "AND (#{condition} " if condition
      find_all(sql, order, limit)
    end

    def find_first_published(condition = "")
      find_first("published != 0 AND (#{condition})")
    end
  end
end
