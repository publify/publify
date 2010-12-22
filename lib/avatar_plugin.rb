require 'typo_plugins'

module TypoPlugins

  class AvatarPlugin < Base

    class << self
      def kind
        :avatar
      end

      def get_avatar(options = {})
        raise NotImplementedError
      end

      def name
        raise NotImplementedError
      end
    end # << self

  end

end
