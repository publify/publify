class AuthorsController < ContentController
  layout :theme_layout

  def show
    @author = User.find_by_login(params[:id])
    raise ActiveRecord::RecordNotFound unless @author
    @articles = @author.articles

    respond_to do |format|
      format.html do
        render
      end
      format.rss do
        auto_discovery_feed(:only_path => false)
        render_feed "rss"
      end
      format.atom do
        render_feed "atom"
      end
    end
  end

  private

  def render_feed format
    render "show_#{format}_feed", :layout => false
  end
end
