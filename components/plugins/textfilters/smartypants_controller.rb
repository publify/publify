class Plugins::Textfilters::SmartypantsController < TextFilterPlugin::PostProcess
  def self.display_name
    "Smartypants"
  end

  def self.description
    'Converts HTML to use typographically correct quotes and dashes'
  end

  def self.filtertext(controller,text,params)
    RubyPants.new(text).to_html
  end
end
