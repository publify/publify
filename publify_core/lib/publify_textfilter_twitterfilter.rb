# frozen_string_literal: true

require "text_filter_plugin"
require "html/pipeline"
require "html/pipeline/hashtag/hashtag_filter"

class PublifyApp
  class Textfilter
    class Twitterfilter < TextFilterPlugin::PostProcess
      plugin_display_name "HTML Filter"
      plugin_description "Strip HTML tags"

      class TwitterHashtagFilter < HTML::Pipeline::HashtagFilter
        def initialize(text, context = nil, result = nil)
          super(text,
                context.reverse_merge(
                  tag_url: "https://twitter.com/search?q=%%23%<tag>s&src=tren&mode=realtime",
                  tag_link_attr: ""
                ),
                result)
        end
      end

      class TwitterMentionFilter < HTML::Pipeline::MentionFilter
        def initialize(text, context = nil, result = nil)
          super(text,
                context.reverse_merge(base_url: "https://twitter.com"),
                result)
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
        pipeline = HTML::Pipeline.new [
          HTML::Pipeline::AutolinkFilter,
          TwitterHashtagFilter,
          TwitterMentionFilter
        ], { link_mode: :all }

        pipeline.call(text)[:output].to_s
      end
    end
  end
end
