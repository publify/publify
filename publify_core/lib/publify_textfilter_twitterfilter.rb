# frozen_string_literal: true

require "text_filter_plugin"

class PublifyApp
  class Textfilter
    class Twitterfilter < TextFilterPlugin::PostProcess
      plugin_display_name "HTML Filter"
      plugin_description "Strip HTML tags"

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

        # @mention
        text.to_s.split.grep(/@\w+/) do |item|
          item = item.strip_html
          uri = ERB::Util.html_escape("https://twitter.com/#{item.delete("@")}")
          text = text.gsub(item, "<a href='#{uri}'>#{item}</a>")
        end

        text
      end
    end
  end
end
