class Plugins::Textfilters::MacroPostController < TextFilterPlugin
  def self.display_name
    "MacroPost"
  end

  def self.description
    "Macro expansion meta-filter (post-markup)"
  end

  def self.filtertext(controller,text,params)
    filterparams = params[:filterparams]
    
    macros = TextFilter.available_filter_types['macropost']
    macros.inject(text) do |text,macro|
      macro.filtertext(controller,text,params)
    end
  end
end

