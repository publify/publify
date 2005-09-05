require 'application'
require 'plugins'

class TextFilterPlugin < ApplicationController
  uses_component_template_root
  include ApplicationHelper
  
  class << self
    include TypoPlugins
  end
  
  # Disable HTML errors for subclasses
  def rescue_action(e) 
    raise e 
  end
    
  # The name that needs to be used when refering to the plugin's
  # controller in render statements
  def self.component_name
    if (self.to_s =~ /::([a-zA-Z]+)Controller/)
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
  
  # The name that shows up in the UI
  def self.display_name
    # This is the default, but it's best to override it
    short_name
  end
  
  def self.description
    short_name
  end
  
  def self.default_config
    {}
  end

  def self.help_text
    ""
  end
end

class TextFilterPlugin::Markup < TextFilterPlugin
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

    attributes
  end

  def filtertext
    text = params[:text]
    filterparams = params[:filterparams]
    regex1 = /<typo:#{self.class.short_name}[^>]*\/>/
    regex2 = /<typo:#{self.class.short_name}([^>]*)>(.*?)<\/typo:#{self.class.short_name}>/m
    
    new_text = text.gsub(regex1) do |match|
      macrofilter(self.class.attributes_parse(match),filterparams)
    end
    
    new_text = new_text.gsub(regex2) do |match|
      macrofilter(self.class.attributes_parse($1.to_s),filterparams,$2.to_s)
    end

    render :text => new_text
  end

end

class TextFilterPlugin::MacroPre < TextFilterPlugin::Macro
end

class TextFilterPlugin::MacroPost < TextFilterPlugin::Macro
end

class TextFilterPlugin::PostProcess < TextFilterPlugin
end

class TextfilterController < ApplicationController
  def public_action
    filter = params[:filter]
    action = params[:public_action]
    plugin = TextFilter.filters_map[filter]
    
    if(plugin and plugin.plugin_public_actions.include? action.to_sym)
      render_component(:controller => "plugins/textfilters/#{params[:filter]}", 
        :action => params[:public_action], :params => params)
    else
      render :text => '', :status => 404
    end
  end
end

Dir["#{RAILS_ROOT}/components/plugins/textfilters/[_a-z]*.rb"].each do |f|
  require_dependency f
end
