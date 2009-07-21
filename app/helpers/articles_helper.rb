module ArticlesHelper
  def feed_atom
    if params[:action] == 'search'
      url_for(:only_path => false,:format => :atom, :q => params[:q])
    else
      @auto_discovery_url_atom
    end
  end

  def feed_rss
    if params[:action] == 'search'
      url_for(:only_path => false,:format => :rss, :q => params[:q])
    else
      @auto_discovery_url_rss
    end
  end
end
