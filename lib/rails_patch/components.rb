module ActionController #:nodoc:
  module Components
    module InstanceMethods
      private

      # By default, this logs *WAY* too much data for us when we're doing sidebars--I've seen ~2M
      # per hit.  This has a negative impact on performance.
      def component_logging(options)
        unless logger.nil?
          logger.info do
            "Start rendering component (#{options.reject {|k,v| k==:params}.inspect}): "
          end
          result = yield
          logger.info("\n\nEnd of component rendering") unless logger.nil?
          return result
        end
        yield
      end
    end
  end
end
