class AuthorsController < ContentController
  layout :theme_layout
  
  def show
    @author = User.find_by_login(params[:id]) 
    raise ActiveRecord::RecordNotFound unless @author

    respond_to do |format|
      format.html
      format.rss do
        @limit = this_blog.limit_rss_display
        auto_discovery_feed(:only_path => false)
        render :partial => "articles/rss20_feed", :object => @author.articles
      end
      format.atom do
        @limit = this_blog.limit_rss_display
        render :partial => "articles/atom_feed", :object => @author.articles
      end
    end
  end
end