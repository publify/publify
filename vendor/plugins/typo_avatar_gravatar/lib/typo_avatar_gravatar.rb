# TypoAvatarGravatar

module TypoPlugins

  class Gravatar < AvatarPlugin
    @description = 'Provide user avatar image throught the http://gravatar.com service.'

    class << self

      def get_avatar(options={})
        email = options.delete(:email) || ''
        gravatar_tag(email, options)
      end

      def name
        'Gravatar'
      end
    
      private
       
      # Generate the image tag for a commenters gravatar based on their email address
      # Valid options are described at http://www.gravatar.com/implement.php
      def gravatar_tag(email, options={})
        options[:gravatar_id] = Digest::MD5.hexdigest(email.strip)
        options[:default] = CGI::escape(options[:default]) if options.include?(:default)
        options[:size] ||= 48
  
        url = "http://www.gravatar.com/avatar.php?" << options.map { |key,value| "#{key}=#{value}" }.sort.join("&")
        "<img src=\"#{url}\" class=\"avatar gravatar\" />"
      end
    end
  end

end
