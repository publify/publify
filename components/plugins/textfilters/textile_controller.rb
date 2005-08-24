class Plugins::Textfilters::TextileController < TextFilterPlugin::Markup
  def self.display_name
    "Textile"
  end

  def self.description
    'Textile markup language'
  end

  def filtertext
    text = params[:text]
    render :text => RedCloth.new(text).to_html
  end
end
