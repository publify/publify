class TagsController < ContentController
  before_action :auto_discovery_feed, only: [:show, :index]
  layout :theme_layout

  def index
    @tags = Tag.page(params[:page]).per(100)
    @page_title = controller_name.capitalize
    @keywords = ''
    @description = "#{self.class.to_s.sub(/Controller$/, '')} for #{this_blog.blog_name}"
  end

  def show
    @tag = Tag.find_by!(name: params[:id])

    @page_title = this_blog.tag_title_template.to_title(@tag, this_blog, params)
    @description = @tag.description.to_s
    @articles = @tag.
      articles.includes(:blog, :user, :tags, :resources, :text_filter).
      published.page(params[:page]).per(10)

    respond_to do |format|
      format.html do
        if @articles.empty?
          raise ActiveRecord::RecordNotFound
        else
          @keywords = this_blog.meta_keywords
          render template_name(params[:id])
        end
      end

      format.atom do
        @articles = @articles[0, this_blog.limit_rss_display]
        render 'articles/index_atom_feed', layout: false
      end

      format.rss do
        @articles = @articles[0, this_blog.limit_rss_display]
        render 'articles/index_rss_feed', layout: false
      end
    end
  end

  private

  def template_name(value)
    template_exists?("tags/#{value}") ? value : :show
  end
end
