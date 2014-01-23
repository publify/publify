require 'publify_plugins'

module PublifyPlugins

  class AvatarPlugin < Base

    def self.kind
      :avatar
    end

    def self.get_avatar(options = {})
      raise NotImplementedError
    end

    def self.name
      raise NotImplementedError
    end

  end

end
