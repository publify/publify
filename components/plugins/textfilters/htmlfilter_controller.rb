class Plugins::Textfilters::HtmlfilterController < TextFilterPlugin
  plugin_display_name "HTML Filter"
  plugin_description 'Strip HTML tags'

  def self.filtertext(controller,content,text,params)
    text.to_s.gsub( "<", "&lt;" ).gsub( ">", "&gt;" )
  end
end
