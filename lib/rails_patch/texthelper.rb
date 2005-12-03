# Make certain TextHelpers accessible from Controllers.
# From http://pinds.com/articles/2005/10/18/rails-calling-view-helpers-from-your-controller

module ActionView
  module Helpers
    module TextHelper
      module_function :sanitize, :strip_tags, :auto_link, :auto_link_email_addresses, :auto_link_urls
      
      def self.tag_options(options)
        ActionView::Helpers::TagHelper.tag_options(options)
      end
    end
  end
end

module ActionView
  module Helpers
    module TagHelper
      module_function :tag_options, :convert_booleans, :boolean_attribute
    end
  end
end
