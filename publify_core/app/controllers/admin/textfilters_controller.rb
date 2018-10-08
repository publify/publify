# frozen_string_literal: true

class Admin::TextfiltersController < Admin::BaseController
  def macro_help
    @macro = TextFilterPlugin.available_filters.find { |filter| filter.short_name == params[:id] }
    render html: BlueCloth.new(@macro.help_text).to_html
  end
end
