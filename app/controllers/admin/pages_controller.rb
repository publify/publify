require 'base64'

class Admin::PagesController < Admin::BaseController
  layout "administration", :except => 'show'
  cache_sweeper :blog_sweeper

  def index
    @search = params[:search] ? params[:search] : {}
    @pages = Page.search_paginate(@search, :page => params[:page], :per_page => this_blog.admin_display_elements)
  end

  def show
    @page = Page.find(params[:id])
  end

  accents = { ['á','à','â','ä','ã','Ã','Ä','Â','À'] => 'a',
    ['é','è','ê','ë','Ë','É','È','Ê'] => 'e',
    ['í','ì','î','ï','I','Î','Ì'] => 'i',
    ['ó','ò','ô','ö','õ','Õ','Ö','Ô','Ò'] => 'o',
    ['œ'] => 'oe',
    ['ß'] => 'ss',
    ['ú','ù','û','ü','U','Û','Ù'] => 'u',
    ['ç','Ç'] => 'c'
  }

  FROM, TO = accents.inject(['','']) { |o,(k,v)|
    o[0] << k * '';
    o[1] << v * k.size
    o
  }

  def new
    @macros = TextFilter.available_filters.select { |filter| TextFilterPlugin::Macro > filter }
    @page = Page.new(params[:page])
    @page.user_id = current_user.id
    @page.text_filter ||= current_user.text_filter
    if request.post? 
      if @page.name.blank?
        @page.name = @page.title.tr(FROM, TO).gsub(/<[^>]*>/, '').to_url 
      end
      @page.published_at = Time.now
      if @page.save
        flash[:notice] = _('Page was successfully created.')
        redirect_to :action => 'index'
      end
    end
  end

  def edit
    @macros = TextFilter.available_filters.select { |filter| TextFilterPlugin::Macro > filter }
    @page = Page.find(params[:id])
    @page.attributes = params[:page]
    if request.post? and @page.save
      flash[:notice] = _('Page was successfully updated.')
      redirect_to :action => 'index'
    end
  end

  def destroy
    @page = Page.find(params[:id])
    if request.post?
      @page.destroy
      redirect_to :action => 'index'
    end
  end
  
  def insert_editor
    return unless params[:editor].to_s =~ /simple|visual/
    current_user.editor = params[:editor].to_s
    current_user.save!
    
    render :partial => "#{params[:editor].to_s}_editor"
  end
  
end
