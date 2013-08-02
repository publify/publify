class PublifyApp
  class Textfilter
    class Twitterfilter < TextFilterPlugin::PostProcess
      plugin_display_name "HTML Filter"
      plugin_description 'Strip HTML tags'

      def self.filtertext(blog,content,text,params)
        # First, autolink
        text = text.to_s
        URI.extract(text, ["http", "https", "mailto", "gopher"]) do |item|
          text = text.gsub(item, "<a href='#{item}'>#{item}</a>")
        end
        
        # hashtags
        text.split.grep(/^#\w+/) do |item|
          # strip_html because Ruby considers "#prouddad</p>" as a word
          uri = URI.escape("https://twitter.com/search?q=#{item.strip_html}&src=tren&mode=realtime")
          text = text.gsub(item, "<a href='#{uri}'>#{item.strip_html}</a>")
        end
        
        # @mention
        text.to_s.split.grep(/@\w+/) do |item|
          uri = URI.escape("https://twitter.com/#{item.strip_html.gsub('@', '')}")
          text = text.gsub(item, "<a href='#{uri}'>#{item.strip_html}</a>")
        end
        
        return text
      end
    end
  end
end
