require 'base64'

class Admin::PagesController < Admin::BaseController
  def index
    list
    render :action => 'list'
  end

  def list
    if params[:order] and params[:order] =~ /title|created_at|state/
      if params[:sense] and params[:sense] == 'desc'
        order = params[:order] + " asc"
      else
        order = params[:order] + " desc"        
      end
    else
      order = 'title ASC'
    end

    @pages = Page.find(:all, :order => order)
    @page = Page.new(params[:page])
    @page.text_filter ||= this_blog.text_filter
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new(params[:page])
    @page.user_id = current_user.id
    @page.text_filter ||= this_blog.text_filter
    if request.post? and @page.save
      flash[:notice] = 'Page was successfully created.'
      redirect_to :action => 'show', :id => @page.id
    end
  end

  def edit
    @page = Page.find(params[:id])
    @page.attributes = params[:page]
    if request.post? and @page.save
      flash[:notice] = 'Page was successfully updated.'
      redirect_to :action => 'show', :id => @page.id
    end
  end

  def destroy
    @page = Page.find(params[:id])
    if request.post?
      @page.destroy
      redirect_to :action => 'list'
    end
  end

  def preview
    headers["Content-Type"] = "text/html; charset=utf-8"
    @page = this_blog.pages.build(params[:page])
    data = render_to_string(:layout => "minimal")
    data = Base64.encode64(data).gsub("\n", '')
    data = "data:text/html;charset=utf-8;base64,#{data}"
    render :text => data
  end
end
