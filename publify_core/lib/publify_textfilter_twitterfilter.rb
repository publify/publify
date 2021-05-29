# frozen_string_literal: true

require "text_filter_plugin"
require "html/pipeline"

class PublifyApp
  class Textfilter
    class Twitterfilter < TextFilterPlugin::PostProcess
      plugin_display_name "HTML Filter"
      plugin_description "Strip HTML tags"

      class TwitterMentionFilter < HTML::Pipeline::MentionFilter
        def initialize(text)
          super(text, base_url: "https://twitter.com")
        end

        # Override base mentions finder, treating @mention just like any other @foo.
        def self.mentioned_logins_in(text, username_pattern = UsernamePattern)
          text.gsub MentionPatterns[username_pattern] do |match|
            login = Regexp.last_match(1)
            yield match, login, false
          end
        end

        # Override base link creator, removing the class
        def link_to_mentioned_user(login)
          result[:mentioned_usernames] |= [login]

          url = base_url.dup
          url << "/" unless %r{[/~]\z}.match?(url)

          "<a href='#{url << login}'>" \
            "@#{login}" \
            "</a>"
        end
      end

      def self.filtertext(text)
        # First, autolink
        helper = Feedback::ContentTextHelpers.new
        text = helper.auto_link(text)

        # hashtags
        text.split.grep(/^#\w+/) do |item|
          # strip_html because Ruby considers "#prouddad</p>" as a word
          item = item.strip_html
          search_item = URI.encode_www_form_component(item)

          uri = "https://twitter.com/search?q=#{search_item}&src=tren&mode=realtime"
          text = text.gsub(item, "<a href='#{uri}'>#{item}</a>")
        end

        TwitterMentionFilter.new(text).call.to_s
      end
    end
  end
end
