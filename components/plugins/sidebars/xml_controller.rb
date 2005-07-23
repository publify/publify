class Plugins::Sidebars::XmlController < Sidebars::Plugin
  def self.display_name
    "XML Syndication"
  end

  def self.description
    "RSS and Atom feeds"
  end
  
  def self.default_config
    {'articles' => true, 'comments' => true, 'trackbacks' => false }
  end
  
  def configure
  end
end
