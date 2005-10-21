class Plugins::Textfilters::TextileController < TextFilterPlugin::Markup
  def self.display_name
    "Textile"
  end

  def self.description
    'Textile markup language'
  end

  def self.filtertext(controller,text,params)
    RedCloth.new(text).to_html
  end
end
