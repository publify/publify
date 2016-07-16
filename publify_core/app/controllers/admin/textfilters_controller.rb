class Admin::TextfiltersController < Admin::BaseController
  def macro_help
    @macro = TextFilterPlugin.available_filters.find { |filter| filter.short_name == params[:id] }
    render text: BlueCloth.new(@macro.help_text).to_html
  end
end
