class Admin::SeoController < Admin::BaseController
  cache_sweeper :blog_sweeper
  before_action :set_setting, only: [:index, :titles]

  def index
  end

  def permalinks
    if request.post?
      update_settings
    else
      set_setting
      if @setting.permalink_format != '/%year%/%month%/%day%/%title%' &&
          @setting.permalink_format != '/%year%/%month%/%title%' &&
          @setting.permalink_format != '/%title%'
        @setting.custom_permalink = @setting.permalink_format
        @setting.permalink_format = 'custom'
      end
    end
  end

  def update
    update_settings if request.post?
  rescue ActiveRecord::RecordInvalid
    render params[:from]
  end

  private

  def update_settings
    if params[:setting]['permalink_format'] && params[:setting]['permalink_format'] == 'custom'
      params[:setting]['permalink_format'] = params[:setting]['custom_permalink']
    end
    update_settings_with!(params[:setting])
    redirect_to action: params[:from]
  end

  def set_setting
    @setting = this_blog
  end
end
