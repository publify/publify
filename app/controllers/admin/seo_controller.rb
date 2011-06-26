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
  
end
