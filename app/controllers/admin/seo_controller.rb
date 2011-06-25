class Admin::SeoController < Admin::BaseController
  layout 'administration'

  cache_sweeper :blog_sweeper

  def index
    load_settings
    if File.exists? "#{::Rails.root.to_s}/public/robots.txt"
      @setting.robots = ""
      file = File.readlines("#{::Rails.root.to_s}/public/robots.txt")
      file.each do |line|
        @setting.robots << line
      end
    end
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

end
