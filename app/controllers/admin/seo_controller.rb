class Admin::SeoController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index
    load_settings
    if File.exists? "#{::Rails.root.to_s}/public/robots.txt"
      @setting.robots = ""
      file = File.readlines("#{::Rails.root.to_s}/public/robots.txt")
      file.each do |line|
        @setting.robots << line
      end
    else
      build_robots
    end
  end

  def permalinks 
    if request.post?
      if params[:setting]['permalink_format'] and params[:setting]['permalink_format'] == 'custom'
        params[:setting]['permalink_format'] = params[:setting]['custom_permalink']
      end
      update
      return
    end

    load_settings
    if @setting.permalink_format != '/%year%/%month%/%day%/%title%' and
      @setting.permalink_format != '/%year%/%month%/%title%' and
      @setting.permalink_format != '/%title%'
      @setting.custom_permalink = @setting.permalink_format
      @setting.permalink_format = 'custom'
    end
  end
  
  def titles
    load_settings
  end

  def update
    if request.post?
      Blog.transaction do
        params[:setting].each { |k,v| this_blog.send("#{k.to_s}=", v) }
        this_blog.save
        flash[:notice] = _('config updated.')
      end

      save_robots unless params[:setting][:robots].blank?

      redirect_to :action => params[:from]
    end
  rescue ActiveRecord::RecordInvalid
    render params[:from]
  end

  private
  def load_settings
    @setting = this_blog
  end

  def save_robots
    if File.writable? "#{::Rails.root.to_s}/public/robots.txt"
      robots = File.new("#{::Rails.root.to_s}/public/robots.txt", "r+")
      robots.write(params[:setting][:robots])
      robots.close
    end
  end
  
  def build_robots
    robots = File.new("#{::Rails.root.to_s}/public/robots.txt", "w+")
    line = "User-agent: *\nAllow: /\nDisallow: /admin\n"
    robots.write(line)
    robots.close
    @setting.robots = line
  end

end
