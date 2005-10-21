class Plugins::Textfilters::MacroPreController < TextFilterPlugin
  def self.display_name
    "MacroPre"
  end

  def self.description
    "Macro expansion meta-filter (pre-markup)"
  end

  def self.filtertext(controller,text,params)
    filterparams = params[:filterparams]
    
    macros = TextFilter.available_filter_types['macropre']
    macros.inject(text) do |text,macro|
      macro.filtertext(controller,text,params)
    end
  end
end

