require 'publify_plugins'

module PublifyPlugins
  class AvatarPlugin < Base
    def self.kind
      :avatar
    end

    def self.get_avatar(_options = {})
      fail NotImplementedError
    end

    def self.name
      fail NotImplementedError
    end
  end
end
