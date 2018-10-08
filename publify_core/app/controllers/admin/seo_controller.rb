# frozen_string_literal: true

class Admin::SeoController < Admin::BaseController
  before_action :set_setting
  before_action :set_section

  def show
    if @setting.permalink_format != '/%year%/%month%/%day%/%title%' &&
        @setting.permalink_format != '/%year%/%month%/%title%' &&
        @setting.permalink_format != '/%title%'
      @setting.custom_permalink = @setting.permalink_format
      @setting.permalink_format = 'custom'
    end
  end

  def update
    settings_params[:permalink_format] = settings_params[:custom_permalink] if settings_params[:permalink_format] == 'custom'
    if @setting.update(settings_params)
      flash[:success] = I18n.t('admin.settings.update.success')
      redirect_to admin_seo_path(section: @section)
    else
      flash[:error] = I18n.t('admin.settings.update.error',
                             messages: this_blog.errors.full_messages.join(', '))
      render :show
    end
  end

  private

  def settings_params
    @settings_params ||= params.require(:setting).permit!
  end

  VALID_SECTIONS = %w(general titles permalinks).freeze

  def set_section
    section = params[:section]
    @section = VALID_SECTIONS.include?(section) ? section : 'general'
  end

  def set_setting
    @setting = this_blog
  end
end
