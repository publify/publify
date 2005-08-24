class Plugins::Textfilters::HtmlfilterController < TextFilterPlugin
  def self.display_name
    "HTML Filter"
  end

  def self.description
    'Strip HTML tags'
  end

  def filtertext
    text = params[:text].to_s
    render :text => text.gsub( "<", "&lt;" ).gsub( ">", "&gt;" )
  end
end
