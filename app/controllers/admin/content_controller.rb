class Admin::ContentController < Admin::BaseController
  def index
    list
    render_action 'list'
  end

  def list
    @articles_pages, @articles = with_blog_scoped_classes do
      paginate(:article, :per_page => 15, :order_by => "created_at DESC",
               :parameter => 'id')
    end
    setup_categories
    @article = this_blog.articles.build(params[:article])
  end

  def show
    @article = Article.find(params[:id])
    setup_categories
    @resources = Resource.find(:all, :order => 'created_at DESC')
  end

  def new; new_or_edit; end
  def edit; new_or_edit; end

  def destroy
    @article = Article.find(params[:id])
    if request.post?
      @article.destroy
      redirect_to :action => 'list'
    end
  end

  def category_add; do_add_or_remove_fu; end
  alias_method :category_remove, :category_add
  alias_method :resource_add,    :category_add
  alias_method :resource_remove, :category_add

  def preview
    @headers["Content-Type"] = "text/html; charset=utf-8"
    @article = Article.new(params[:article])
    render :layout => false
  end

  def attachment_box_add
    render :partial => 'admin/content/attachment', :locals => { :attachment_num => params[:id] }
  end

  def attachment_box_remove
    render :inline => "<%= javascript_tag 'document.getElementById(\"attachments\").removeChild(document.getElementById(\"attachment_#{params[:id]}\")); return false;' -%>"
  end

  def attachment_save(attachment)
    begin
      Resource.create(:filename => attachment.original_filename,
                      :mime => attachment.content_type.chomp, :created_at => Time.now).write_to_disk(attachment)
    rescue => e
      logger.info(e.message)
      nil
    end
  end

  protected

  attr_accessor :resources, :categories, :resource, :category

  def do_add_or_remove_fu
    attrib, action = params[:action].split('_')
    @article = Article.find(params[:id])
    self.send("#{attrib}=", self.class.const_get(attrib.classify).find(params["#{attrib}_id"]))
    send("setup_#{attrib.pluralize}")
    @article.send(attrib.pluralize).send(real_action_for(action), send(attrib))
    @article.save
    render :partial => "show_#{attrib.pluralize}"
  end

  def real_action_for(action); { 'add' => :<<, 'remove' => :delete}[action]; end

  def new_or_edit
    get_or_build_article
    params[:article] ||= {}

    @article.attributes = (params[:article])
    setup_categories
    @selected = @article.categories.collect { |c| c.id }
    if request.post?
      set_article_author
      save_attachments
      if @article.save
        set_article_categories
        set_the_flash
        redirect_to :action => 'show', :id => @article.id
      end
    end
  end

  def set_the_flash
    case params[:action]
    when 'new'
      flash[:notice] = 'Article was successfully created'
    when 'edit'
      flash[:notice] = 'Article was successfully updated.'
    else
      raise "I don't know how to tidy up action: #{params[:action]}"
    end
  end

  def set_article_author
    return if @article.author
    @article.author = session[:user].login
    @article.user   = session[:user]
  end

  def save_attachments
    return if params[:attachments].nil?
    params[:attachments].each do |k,v|
      a = attachment_save(v)
      @article.resources << a unless a.nil?
    end
  end

  def set_article_categories
    @article.categories.clear
    @article.categories = Category.find(params[:categories]) if params[:categories]
    @selected = params[:categories] || []
  end

  def get_or_build_article
    @article = case params[:action]
               when 'new'
                 art = this_blog.articles.build
                 art.allow_comments = this_blog.default_allow_comments
                 art.allow_pings    = this_blog.default_allow_pings
                 art.published      = true
                 art
               when 'edit'
                 this_blog.articles.find(params[:id])
               else
                 raise "Don't know how to get article for action: #{params[:action]}"
               end
  end

  def setup_categories
    @categories = Category.find(:all, :order => 'UPPER(name)')
  end

  def setup_resources
    @resources = Resource.find(:all, :order => 'created_at DESC')
  end
end
