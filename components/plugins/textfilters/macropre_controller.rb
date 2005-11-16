class Plugins::Textfilters::MacroPreController < TextFilterPlugin
  plugin_display_name "MacroPre"
  plugin_description "Macro expansion meta-filter (pre-markup)"

  def self.filtertext(controller,text,params)
    filterparams = params[:filterparams]
    
    macros = TextFilter.available_filter_types['macropre']
    macros.inject(text) do |text,macro|
      macro.filtertext(controller,text,params)
    end
  end
end

