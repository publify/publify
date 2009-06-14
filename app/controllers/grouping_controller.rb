class GroupingController < ContentController
  before_filter :auto_discovery_feed, :only => [:show, :index]
  layout :theme_layout
  cache_sweeper :blog_sweeper

  cached_pages = [:index, :show]
  caches_page *cached_pages

  class << self
    def grouping_class(klass = nil)
      if klass
        @grouping_class = klass
      end
      @grouping_class ||= \
        self.to_s \
        .sub(/Controller$/,'') \
        .singularize.constantize
    end

    def ivar_name
      @ivar_name ||= "@#{to_s.sub(/Controller$/, '').underscore}"
    end
  end

  def index
    set_noindex
    self.groupings = grouping_class.paginate(:page => params[:page], :per_page => 100)
    @page_title = "#{self.class.to_s.sub(/Controller$/,'')}"
    @keywords = ""
    @description = "#{_(self.class.to_s.sub(/Controller$/,''))} #{'for'} #{this_blog.blog_name}"
    @description << "#{_('page')} #{params[:page]}" if params[:page]
    render_index(groupings)
  end

  def show
    set_noindex
    grouping = grouping_class.find_by_permalink(params[:id])

    @page_title = "#{_(self.class.to_s.sub(/Controller$/,'').singularize)} #{grouping.name}, "

    if grouping.respond_to? :description and
        not grouping.description.nil?
      @page_title += grouping.description
    else
      @page_title += "#{_('everything about')} "

      if grouping.respond_to? :display_name and
          not grouping.display_name.nil?
        @page_title += grouping.display_name
      else
        @page_title += grouping.name
      end
    end

    @page_title << " page " << params[:page] if params[:page]
    @description = (grouping.description.blank?) ? "" : grouping.description
    @keywords = (grouping.keywords.blank?) ? "" : grouping.keywords
    @articles = grouping.articles.paginate(:page => params[:page], :conditions => { :published => true}, :per_page => 10)
    render_articles
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

  def render_index(groupings)
    respond_to do |format|
      format.html do
        unless template_exists?
          @grouping_class = self.class.grouping_class
          @groupings = groupings
          render :template => 'articles/groupings'
        end
      end
    end
  end

  def render_articles
    respond_to do |format|
      format.html do
        if @articles.empty?
          redirect_to this_blog.base_url, :status => 301
          return
        end

        render :template => 'articles/index' unless template_exists?
      end

      format.atom { render_feed 'atom_feed',  @articles }
      format.rss  { render_feed 'rss20_feed', @articles }
    end
  end

  def render_feed(template, collection)
    articles = collection[0,this_blog.limit_rss_display]
    render :partial => template.sub(%r{^(?:articles/)?}, 'articles/'), :object => articles
  end
  
  private
  def set_noindex
    # irk there must be a better way to do this
    @noindex = 1 if (grouping_class.to_s.downcase == "tag" and this_blog.index_tags == false)
    @noindex = 1 if (grouping_class.to_s.downcase == "category" and this_blog.index_categories == false)
    @noindex = 1 unless params[:page].blank?
  end

  def template_exists?(path = default_template_name)
    self.view_paths.find_template(path, response.template.template_format)
  rescue ActionView::MissingTemplate
    false
  end
end
