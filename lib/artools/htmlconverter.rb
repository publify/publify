require_dependency "html_engine"

module HtmlConversion
  
  def self.append_features(base)
    base.extend(ClassMethods)        
  end
  
  module ClassMethods    
    def converts_to_html(*symbols)
      for symbol in symbols
        class_eval <<-ENV
          before_save :transform_#{symbol}
          
          def transform_#{symbol}
            self.#{symbol}_html = HtmlEngine.transform(#{symbol})
          end
        ENV
      end
    end
  end
end

