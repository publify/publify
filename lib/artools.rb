require_dependency "artools/htmlconverter"
require_dependency "artools/publisher"

ActiveRecord::Base.class_eval do
  include HtmlConversion
  include Publishable
end