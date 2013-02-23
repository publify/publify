class AuthorsController < ContentController
  layout :theme_layout

  def show
    @author = User.find_by_login(params[:id])
    raise ActiveRecord::RecordNotFound unless @author
    @articles = @author.articles.published
    @page_title = this_blog.author_title_template.to_title(@author, this_blog, params)
    @keywords = this_blog.meta_keywords
    @description = this_blog.author_desc_template.to_title(@author, this_blog, params)

    auto_discovery_feed(:only_path => false)

    respond_to do |format|
      format.html do
        render
      end
      format.rss do
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
