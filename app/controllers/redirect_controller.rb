class RedirectController < ApplicationController
  def redirect
    r = Redirect.find_by_from_path(params[:from])
    
    if(r)
      # From http://pinds.com/articles/2005/11/06/rails-how-to-do-a-301-redirect, thanks
      headers["Status"] = "301 Moved Permanently"
      redirect_to r.to_path
    else
      render :text => "Page not found", :status => 404
    end
  end
end
