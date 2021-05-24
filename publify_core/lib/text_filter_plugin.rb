# frozen_string_literal: true

require "publify_plugins"

class TextFilterPlugin
  class << self
    include PublifyPlugins
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::TagHelper
  end

  @@filter_map = {}
  def self.inherited(sub)
    super

    if sub.to_s.start_with?("Plugin", "PublifyTextfilter", "PublifyApp::Textfilter")
      name = sub.short_name
      @@filter_map[name] = sub
    end
  end

  def self.filter_map
    @@filter_map
  end

  def self.available_filters
    filter_map.values
  end

  def self.available_filter_types
    unless @cached_filter_types
      types = { "macropre" => [],
                "macropost" => [],
                "markup" => [],
                "postprocess" => [],
                "other" => [] }

      available_filters.each { |filter| types[filter.filter_type].push(filter) }

      @cached_filter_types = types
    end
    @cached_filter_types
  end

  def self.macro_filters
    macro_pre_filters + macro_post_filters
  end

  def self.macro_pre_filters
    available_filter_types["macropre"]
  end

  def self.macro_post_filters
    available_filter_types["macropost"]
  end

  def self.expand_filter_list(filter_list)
    filter_list.flat_map do |key|
      case key
      when :macropost
        macro_post_filters
      when :macropre
        macro_pre_filters
      else
        filter_map[key.to_s]
      end
    end.compact
  end

  plugin_display_name "Unknown Text Filter"
  plugin_description "Unknown Text Filter Description"

  def self.reloadable?
    false
  end

  # The name that needs to be used when refering to the plugin's
  # controller in render statements
  def self.component_name
    if to_s =~ /::([a-zA-Z]+)$/
      "plugins/textfilters/#{Regexp.last_match[1]}".downcase
    else
      raise "I don't know who I am: #{self}"
    end
  end

  # The name that's stored in the DB.  This is the final chunk of the
  # controller name, like 'markdown' or 'smartypants'.
  def self.short_name
    component_name.split(%r{/}).last
  end

  def self.filter_type
    "other"
  end

  def self.default_config
    {}
  end

  def self.help_text
    ""
  end

  def self.sanitize(*args)
    (@sanitizer ||= Rails::Html::WhiteListSanitizer.new).sanitize(*args)
  end

  def self.default_helper_module!; end

  # Look up a config paramater, falling back to the default as needed.
  def self.config_value(params, name)
    params[:filterparams][name] || default_config[name][:default]
  end

  def self.logger
    @logger ||= ::Rails.logger || Logger.new($stdout)
  end
end

class TextFilterPlugin::PostProcess < TextFilterPlugin
  def self.filter_type
    "postprocess"
  end
end

class TextFilterPlugin::Macro < TextFilterPlugin
  # Utility function -- hand it a XML string like <a href="foo" title="bar">
  # and it'll give you back { "href" => "foo", "title" => "bar" }
  def self.attributes_parse(string)
    attributes = {}

    string.gsub(/([^ =]+="[^"]*")/) do |match|
      key, value = match.split(/=/, 2)
      attributes[key] = value.delete('"')
    end

    string.gsub(/([^ =]+='[^']*')/) do |match|
      key, value = match.split(/=/, 2)
      attributes[key] = value.delete("'")
    end

    attributes
  end

  def self.filtertext(text)
    regex1 = %r{<publify:#{short_name}(?:[ \t][^>]*)?/>}
    regex2 = %r{<publify:#{short_name}([ \t][^>]*)?>(.*?)</publify:#{short_name}>}m

    new_text = text.gsub(regex1) do |match|
      macrofilter(attributes_parse(match))
    end

    new_text.gsub(regex2) do |_match|
      macrofilter(attributes_parse(Regexp.last_match[1].to_s), Regexp.last_match[2].to_s)
    end
  end
end

class TextFilterPlugin::MacroPre < TextFilterPlugin::Macro
  def self.filter_type
    "macropre"
  end
end

class TextFilterPlugin::MacroPost < TextFilterPlugin::Macro
  def self.filter_type
    "macropost"
  end
end

class TextFilterPlugin::Markup < TextFilterPlugin
  def self.filter_type
    "markup"
  end
end
