class Plugins::Textfilters::NoneController < TextFilterPlugin::Markup
  def self.display_name
    "None"
  end

  def self.description
    'Raw HTML only'
  end

  def self.filter(text,params)
    text
  end
end
