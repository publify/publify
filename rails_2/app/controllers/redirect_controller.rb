class RedirectController < ContentController
  session :off

  def redirect
    r = Redirect.find_by_from_path(params[:from])

    if(r)
      # From http://pinds.com/articles/2005/11/06/rails-how-to-do-a-301-redirect, thanks
      headers["Status"] = "301 Moved Permanently"
      path = r.to_path
      url_root = request.relative_url_root
      path = url_root + path unless url_root.nil? or path[0,url_root.length] == url_root
      redirect_to path
    else
      render :text => "Page not found", :status => 404
    end
  end
end
