class Plugins::Textfilters::MacroPostController < TextFilterPlugin
  plugin_display_name "MacroPost"
  plugin_description "Macro expansion meta-filter (post-markup)"

  def self.filtertext(controller,text,params)
    filterparams = params[:filterparams]
    
    macros = TextFilter.available_filter_types['macropost']
    macros.inject(text) do |text,macro|
      macro.filtertext(controller,text,params)
    end
  end
end

