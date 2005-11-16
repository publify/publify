class Textfilters::SmartypantsController < TextFilterPlugin::PostProcess
  plugin_display_name "Smartypants"
  plugin_description 'Converts HTML to use typographically correct quotes and dashes'

  def self.filtertext(controller,text,params)
    RubyPants.new(text).to_html
  end
end
