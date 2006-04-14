module ActionController #:nodoc:
  module Components
    module InstanceMethods
      private

      # By default, this logs *WAY* too much data for us when we're doing sidebars--I've seen ~2M
      # per hit.  This has a negative impact on performance.
      alias_method :component_logging_with_unfiltered_options, :component_logging
      def component_logging(options, &block)
        component_logging_with_unfiltered_options(options.reject {|k,v| k==:params}, &block)
      end
    end
  end
end
