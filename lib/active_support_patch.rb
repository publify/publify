module ActionView
  module Helpers
    module UrlHelper
      # Monkey-patch mail_to to work on Ruby 2.0.
      # See https://github.com/rails/rails/pull/21402
      # TODO: Remove once this is part of a Rails release.
      def mail_to(email_address, name = nil, html_options = {}, &block)
        html_options, name = name, nil if block_given?
        html_options = (html_options || {}).stringify_keys

        extras = %w( cc bcc body subject ).map! { |item|
          option = html_options.delete(item) || next
          "#{item}=#{Rack::Utils.escape_path(option)}"
        }.compact
        extras = extras.empty? ? '' : '?' + extras.join('&')

        encoded_email_address = ERB::Util.url_encode(email_address.to_str).gsub('%40', '@')
        html_options['href'] = "mailto:#{encoded_email_address}#{extras}"

        content_tag(:a, name || email_address, html_options, &block)
      end
    end
  end
end
