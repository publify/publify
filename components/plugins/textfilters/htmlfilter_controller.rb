class Plugins::Textfilters::HtmlfilterController < TextFilterPlugin
  def self.display_name
    "HTML Filter"
  end

  def self.description
    'Strip HTML tags'
  end

  def self.filtertext(controller,text,params)
    text.to_s.gsub( "<", "&lt;" ).gsub( ">", "&gt;" )
  end
end
