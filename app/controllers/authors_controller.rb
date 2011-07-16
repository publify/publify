class AuthorsController < ContentController
  layout :theme_layout

  def show
    @author = User.find_by_login(params[:id])
    raise ActiveRecord::RecordNotFound unless @author

    respond_to do |format|
      format.html do
        @articles = @author.articles
        render
      end
      format.rss do
        auto_discovery_feed(:only_path => false)
        render_feed "shared/rss20_feed"
      end
      format.atom do
        render_feed "shared/atom_feed"
      end
    end
  end

  private

  def render_feed(template)
    @limit = this_blog.limit_rss_display
    render :partial => template, :locals => { :items => @author.articles, :feed_url => url_for(params) }
  end
end
