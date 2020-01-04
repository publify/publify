# frozen_string_literal: true

require "publify_plugins"
require "avatar_plugin"

# PublifyAvatarGravatar
module PublifyPlugins
  class Gravatar < AvatarPlugin
    extend ActionView::Helpers::TagHelper
    @description = "Provide user avatar image throught the http://gravatar.com service."

    class << self
      def get_avatar(options = {})
        email = options.delete(:email) || ""
        gravatar_tag(email, options)
      end

      def name
        "Gravatar"
      end

      private

      # Generate the image tag for a commenters gravatar based on their email address
      # Valid options are described at http://www.gravatar.com/implement.php
      def gravatar_tag(email, options = {})
        opts = {}
        opts[:gravatar_id] = Digest::MD5.hexdigest(email.strip)
        opts[:default] = CGI.escape(options[:default]) if options.include?(:default)
        opts[:size] = options[:size] || 48
        klass = options[:class] || "avatar gravatar"

        url = +"https://www.gravatar.com/avatar.php?"
        url << opts.map { |key, value| "#{key}=#{value}" }.sort.join("&")
        tag "img", src: url, class: klass, alt: "Gravatar"
      end
    end
  end
end

PublifyPlugins::Keeper.register(PublifyPlugins::Gravatar)
