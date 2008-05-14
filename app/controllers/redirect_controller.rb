class RedirectController < ContentController
  session :off

  def redirect
    # Ugly way to manage redirects, anything better ?
    if (request.request_uri =~ /^\/articles/)
      redirect_to request.request_uri.gsub('/articles', ''), :status => 301
      return
    end

    r = Redirect.find_by_from_path(params[:from])

    if(r)
      path = r.to_path
      url_root = request.relative_url_root
      path = url_root + path unless url_root.nil? or path[0,url_root.length] == url_root
      redirect_to path, :status => 301
    else
      render :text => "Page not found", :status => 404
    end
  end
end
