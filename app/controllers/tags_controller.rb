class TagsController < ContentController
  before_action :auto_discovery_feed, only: [:show, :index]
  layout :theme_layout
  cache_sweeper :blog_sweeper

  caches_page :index, :show, if: proc {|c|
    c.request.query_string == ''
  }

  def self.ivar_name
    @ivar_name ||= "@#{controller_name}"
  end

  def index
    self.groupings = Tag.page(params[:page]).per(100)
    @page_title = controller_name.capitalize
    @keywords = ''
    @description = "#{self.class.to_s.sub(/Controller$/, '')} for #{this_blog.blog_name}"
  end

  def show
    @grouping = Tag.find_by_permalink(params[:id])
    if @grouping.nil?
      @articles = []
    else
      @canonical_url = permalink_with_page @grouping, params[:page]
      @page_title = show_page_title_for @grouping, params[:page]
      @description = @grouping.description.to_s
      @keywords = ''
      @keywords << @grouping.keywords unless @grouping.keywords.blank?
      @keywords << this_blog.meta_keywords unless this_blog.meta_keywords.blank?
      @articles = @grouping.articles.published.page(params[:page]).per(10)
    end
    respond_to do |format|
      format.html do
        if @articles.empty?
          redirect_to this_blog.base_url, status: 301
        elsif template_exists? "#{grouping_name.downcase}/#{params[:id]}"
          render params[:id]
        elsif template_exists? "#{grouping_name.downcase}/show"
          render 'show'
        else
          render 'articles/index'
        end
      end

      format.atom do
        @articles = @articles[0, this_blog.limit_rss_display]
        render 'articles/index_atom_feed', layout: false
      end

      format.rss  do
        @articles = @articles[0, this_blog.limit_rss_display]
        render 'articles/index_rss_feed', layout: false
      end
    end
  end

  protected

  def grouping_class
    self.class.grouping_class
  end

  def groupings=(groupings)
    instance_variable_set(self.class.ivar_name, groupings)
  end

  def groupings
    instance_variable_get(self.class.ivar_name)
  end

  def grouping_name
    @grouping_name ||= self.class.to_s.sub(/Controller$/, '')
  end

  def show_page_title_for(_grouping, _page)
    if grouping_name.singularize == 'Tag'
      @page_title   = this_blog.tag_title_template.to_title(@grouping, this_blog, params)
      @description = this_blog.tag_title_template.to_title(@grouping, this_blog, params)
    end
  end

  # For some reasons, the permalink_url does not take the pagination.
  def permalink_with_page(grouping, page)
    suffix = page.nil? ? '/' : "/page/#{page}/"
    grouping.permalink_url + suffix
  end
end
