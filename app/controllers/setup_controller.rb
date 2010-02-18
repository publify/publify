class SetupController < ApplicationController
  before_filter :check_config
  layout 'accounts'
  
  def index
    if request.post?
      Blog.transaction do
        params[:setting].each { |k,v| this_blog.send("#{k.to_s}=", v) }
        this_blog.save
        redirect_to :controller => 'accounts', :action => 'signup'
      end      
    end
  end
  
  private
  def check_config
    return unless this_blog.configured?
    
    if User.count == 0
      redirect_to :controller => "accounts", :action => "signup" 
    else
      redirect_to :controller => 'articles', :action => 'index'
    end
  end
end