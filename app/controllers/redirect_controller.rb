class RedirectController < ContentController
  session :off

  def redirect
    if (params[:from].first == 'articles')
      path = request.path.sub('/articles', '')
      url_root = self.class.relative_url_root
      path = url_root + path unless url_root.nil?
      redirect_to path, :status => 301
      return
    end

    r = Redirect.find_by_from_path(params[:from].join("/"))

    if(r)
      path = r.to_path
      url_root = self.class.relative_url_root
      path = url_root + path unless url_root.nil? or path[0,url_root.length] == url_root
      redirect_to path, :status => 301
    else
      render :text => "Page not found", :status => 404
    end
  end
end
