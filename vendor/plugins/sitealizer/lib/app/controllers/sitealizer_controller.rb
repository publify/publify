require 'digest/sha1'
SA_CONFIG = YAML::load_file(File.dirname(__FILE__)+'/../../config.yml')

class SitealizerController < ActionController::Base
  
  before_filter :check_access_type, :except => [:login, :logout]
  layout 'sitealizer'
  
  def self.template_root
    "#{RAILS_ROOT}/vendor/plugins/sitealizer/lib/app/views"
  end
  
  def login
    return unless request.post?
    if params[:username] == SA_CONFIG['sitealizer']['username'].to_s && params[:password] == SA_CONFIG['sitealizer']['password'].to_s
      cookies[:sitealizer] = {:value => Digest::SHA1.hexdigest("--#{Time.now.to_i}--#{params[:username]}--")}
      redirect_to :action => 'index'
    else
      flash[:notice] = "Username/Password Invalid"
    end
  end
  
  def logout
    cookies.delete :sitealizer
    redirect_to :action => 'login'
  end
  
  def index
    if !params[:month] && !params[:year]
      params[:month] = sprintf("%02d",Time.now.month)
      params[:year]  = Time.now.year
    end
  end
  
  def menu
    months = []
    years  = []
    f = SiteTracker.find(:all, :limit => 1, :order => 'created_on ASC')
    l = SiteTracker.find(:all, :limit => 1, :order => 'created_on DESC')
    first = !f.empty? ? f.first.created_on : Date.today
    last  = !l.empty? ? l.first.created_on : Date.today
    (first.to_date..last.to_date).each{|d| months << d.month unless months.include?(d.month)}
    (first.to_date..last.to_date).each{|d| years << d.year unless years.include?(d.year)}
    @months = months.sort.map{|m| 
      m=sprintf('%02d',m); 
      "<option #{"selected" if m.to_i == params[:month].to_i  } value=#{m}>#{m}</option>"
    }
    @years  = years.sort.map{|y| 
      "<option #{"selected" if y == params[:year].to_i} value=#{y}>#{y}</option>"
    }
    @cookie = cookies[:sitealizer]
  end
  
  def summary
    @year = nil
    @month = nil
    begin
      if "#{params[:year]}-#{params[:month]}-1".to_time
        @year = params[:year]
        @month = params[:month]
      end
    rescue
      @year = Time.now.year
      @month = sprintf("%02d",Time.now.month)
    end
    @total_hits  = SiteTracker.count_hits(:year => @year, :month => @month)
    @unique_hits = SiteTracker.count_hits(:count => 'DISTINCT ip', :year => @year, :month => @month)
    @daily_hits  = SiteTracker.find_daily_hits(:year => @year, :month => @month)
    @month_hits  = SiteTracker.find_monthly_hits(:year => @year)
    @year_hits   = SiteTracker.count_hits(:date => "#{@year}-%")
    @year_uniq   = SiteTracker.count_hits(:date => "#{@year}-%", :count => "DISTINCT ip")
    file = File.dirname(__FILE__)+'/../../last_update'
    @last_update = File.exists?(file) ? open(file,'r'){|f| f.read.to_time.to_s(:long)} : "Not updated yet"
  end
  
  def hourly_stats
    @year  = params[:year] || Time.now.year
    @month = params[:month] || sprintf("%02d",Time.now.month)
    @total_hits  = SiteTracker.count_hits(:year => @year, :month => @month)
    @hourly_hits = SiteTracker.find_hourly_hits(:year => @year, :month => @month)
  end
  
  def search_stats
    @year  = params[:year] || Time.now.year
    @month = params[:month] || sprintf("%02d",Time.now.month)
    @keywords = SiteTracker.find_search_terms(:year => @year, :month => @month)
    @engines  = SiteTracker.find_domains(:year => @year, :month => @month, :host => request.host)
    @robots   = SiteTracker.find_robots(:year => @year, :month => @month)    
  end
  
  def visitor_info
    @year  = params[:year] || Time.now.year
    @month = params[:month] || sprintf("%02d",Time.now.month) 
    @total_hits  = SiteTracker.count_hits(:year => @year, :month => @month)
    @browsers    = SiteTracker.find_browsers(:year => @year, :month => @month)
    @platforms   = SiteTracker.find_platforms(:year => @year, :month => @month)
    @hosts       = SiteTracker.find_hosts(:year => @year, :month => @month)
    @languages   = SiteTracker.find_languages(:year => @year, :month => @month)
  end
  
  def referrer_stats
    @year  = params[:year] || Time.now.year
    @month = params[:month] || sprintf("%02d",Time.now.month)  
    @total_hits  = SiteTracker.count_hits(:year => @year, :month => @month)
    @referers    = SiteTracker.find_referers(:year => @year, :month => @month)
    @page_urls   = SiteTracker.find_page_urls(:year => @year, :month => @month)
  end
  
  protected
  def check_access_type
    if SA_CONFIG['sitealizer']['access_type'] == 'private'
      unless cookies[:is_admin]
        redirect_to :controller => 'accounts', :action => 'login'
      end
    end
  end

end