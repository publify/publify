class TextFilterPlugin
  class << self
    include TypoPlugins
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::TagHelper
  end

  @@filter_map = {}
  def self.inherited(sub)
    if sub.to_s =~ /^Plugin/ or sub.to_s =~ /^Typo::Textfilter/
      name = sub.short_name
      @@filter_map[name] = sub
    end
  end

  def self.filter_map
    @@filter_map
  end

  plugin_display_name "Unknown Text Filter"
  plugin_description "Unknown Text Filter Description"

  def self.reloadable?
    false
  end

  # The name that needs to be used when refering to the plugin's
  # controller in render statements
  def self.component_name
    if (self.to_s =~ /::([a-zA-Z]+)$/)
      "plugins/textfilters/#{$1}".downcase
    else
      raise "I don't know who I am: #{self.to_s}"
    end
  end

  # The name that's stored in the DB.  This is the final chunk of the
  # controller name, like 'markdown' or 'smartypants'.
  def self.short_name
    component_name.split(%r{/}).last
  end

  def self.default_config
    {}
  end

  def self.help_text
    ""
  end

  def self.sanitize(*args)
    (@sanitizer ||= HTML::WhiteListSanitizer.new).sanitize(*args)
  end

  private

  def self.default_helper_module!
  end

  # Look up a config paramater, falling back to the default as needed.
  def self.config_value(params,name)
    params[:filterparams][name] || default_config[name][:default]
  end

  def self.logger
    @logger ||= ::Rails.logger || Logger.new(STDOUT)
  end
end

class TextFilterPlugin::PostProcess < TextFilterPlugin
end

class TextFilterPlugin::Macro < TextFilterPlugin
  # Utility function -- hand it a XML string like <a href="foo" title="bar">
  # and it'll give you back { "href" => "foo", "title" => "bar" }
  def self.attributes_parse(string)
    attributes = Hash.new

    string.gsub(/([^ =]+="[^"]*")/) do |match|
      key,value = match.split(/=/,2)
      attributes[key] = value.gsub(/"/,'')
    end

    string.gsub(/([^ =]+='[^']*')/) do |match|
      key,value = match.split(/=/,2)
      attributes[key] = value.gsub(/'/,'')
    end

    attributes
  end

  def self.filtertext(blog, content, text, params)
    filterparams = params[:filterparams]
    regex1 = /<typo:#{short_name}(?:[ \t][^>]*)?\/>/
    regex2 = /<typo:#{short_name}([ \t][^>]*)?>(.*?)<\/typo:#{short_name}>/m

    new_text = text.gsub(regex1) do |match|
      macrofilter(blog,content,attributes_parse(match),params)
    end

    new_text = new_text.gsub(regex2) do |match|
      macrofilter(blog,content,attributes_parse($1.to_s),params,$2.to_s)
    end

    new_text
  end
end

class TextFilterPlugin::MacroPre < TextFilterPlugin::Macro
end

class TextFilterPlugin::MacroPost < TextFilterPlugin::Macro
end

class TextFilterPlugin::Markup < TextFilterPlugin
end

class Typo
  class Textfilter
    class MacroPost < TextFilterPlugin
      plugin_display_name "MacroPost"
      plugin_description "Macro expansion meta-filter (post-markup)"

      def self.filtertext(blog,content,text,params)
        filterparams = params[:filterparams]

        macros = TextFilter.available_filter_types['macropost']
        macros.inject(text) do |text,macro|
          macro.filtertext(blog,content,text,params)
        end
      end
    end

    class MacroPre < TextFilterPlugin
      plugin_display_name "MacroPre"
      plugin_description "Macro expansion meta-filter (pre-markup)"

      def self.filtertext(blog,content,text,params)
        filterparams = params[:filterparams]

        macros = TextFilter.available_filter_types['macropre']
        macros.inject(text) do |text,macro|
          macro.filtertext(blog,content,text,params)
        end
      end
    end
  end
end
