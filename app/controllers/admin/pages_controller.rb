require 'base64'

class Admin::PagesController < Admin::BaseController
  layout "administration", :except => 'show'
  def index
    list
    render :action => 'list'
  end

  def list
    conditions = "id > 0"

    if params[:search]
      @search = params[:search]

      if @search[:published_at] and %r{(\d\d\d\d)-(\d\d)} =~ @search[:published_at]
        conditions += " AND created_at LIKE '%#{@search[:published_at]}%'"
      end

      if @search[:user_id] and @search[:user_id].to_i > 0
        conditions += " AND user_id = #{@search[:user_id].to_i}"
      end
      
      if @search[:published] and @search[:published].to_s =~ /0|1/
        conditions += " AND published = #{@search[:published].to_i}"
      end
      
    else
      @search = { :user_id => nil, :published_at => nil, :status => nil }
    end
    
    @pages = Page.find(:all, :conditions => conditions)
    @page = Page.new(params[:page])
    @page.text_filter ||= this_blog.text_filter
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
    @page = Page.new(params[:page])
    @page.user_id = current_user.id
    @page.text_filter ||= this_blog.text_filter
    if request.post? 
      if @page.name.blank?
        @page.name = @page.title.tr(FROM, TO).gsub(/<[^>]*>/, '').to_url 
      end
      @page.published_at = Time.now
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        redirect_to :action => 'list'
      end
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
