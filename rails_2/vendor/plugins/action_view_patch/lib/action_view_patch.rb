require 'action_view/helpers/prototype_helper' unless defined?(ActionView::Helpers::PrototypeHelper)

module ActionView
  module Helpers
    module PrototypeHelper
      alias :_build_observer :build_observer
      def build_observer(klass, name, options = {})
        options[:with] = 'value' unless options[:with]
        class << options[:with]
          def include?(arg)
            arg == "=" ? true : super
          end
        end
        _build_observer(klass, name, options)
      end
    end
  end
end