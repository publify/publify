module PublifyPlugins
  # Deprecated?
  def plugin_public_action(action)
    @@plugin_public_actions ||= []
    @@plugin_public_actions.push action
  end

  # Deprecated?
  def plugin_public_actions
    @@plugin_public_actions
  end

  # Deprecated?
  def plugin_description(description)
    eval "def self.description; '#{description}'; end"
  end

  # Deprecated?
  def plugin_display_name(name)
    eval "def self.display_name; '#{name}'; end"
  end

  unless defined?(Keeper) # Something in rails double require this module. Prevent that to keep @@registered integrity
    class Keeper
      KINDS = [:avatar, :textfilter].freeze
      @@registered = {}

      class << self
        def available_plugins(kind = nil)
          return @@registered.inspect unless kind
          check_kind(kind)
          @@registered ? @@registered[kind] : nil
        end

        def register(klass)
          kind = klass.kind
          check_kind(kind)
          @@registered[kind] ||= []
          @@registered[kind] << klass
          @@registered[kind]
        end

        private

        def check_kind(kind)
          unless KINDS.include?(kind)
            raise ArgumentError,
                  "#{kind} is not part of available plugin targets (#{KINDS.join(',')})"
          end
        end
      end

      private

      def initialize
        raise 'No instance allowed.'
      end
    end
  end # Defined

  class Base
    class << self
      attr_accessor :name
      attr_accessor :description
      attr_reader :registered

      def kind
        :void
      end
    end # << self
  end
end
