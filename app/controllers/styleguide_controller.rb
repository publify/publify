class StyleguideController < ApplicationController
  layout 'styleguide.html.erb'

  def show
    @page_title = 'Styleguide'
  end

  def article_page
    @page_title = 'Article demo page'
  end
end
