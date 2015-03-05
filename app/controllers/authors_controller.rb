class AuthorsController < ContentController
  layout :theme_layout

  def show
    @author = User.find_by_login(params[:id])
    raise ActiveRecord::RecordNotFound unless @author

    @articles = @author.articles.published.page(params[:page]).per(this_blog.per_page(params[:format]))
    @page_title = this_blog.author_title_template.to_title(@author, this_blog, params)
    @keywords = this_blog.meta_keywords
    @description = this_blog.author_desc_template.to_title(@author, this_blog, params)

    auto_discovery_feed(only_path: false)

    respond_to do |format|
      format.rss { render_feed 'rss' }
      format.atom { render_feed 'atom' }
      format.html
    end
  end

  private

  def render_feed(format)
    render "show_#{format}_feed", layout: false
  end
end
