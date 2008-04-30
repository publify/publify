require 'base64'
module Admin; end
class Admin::ContentController < Admin::BaseController
  layout "administration", :except => 'show'

  def auto_complete_for_article_keywords
    @items = Tag.find_with_char params[:article][:keywords].strip
    render :inline => "<%= auto_complete_result @items, 'name' %>"
  end
  
  def index
    list
    render :action => 'list'
  end

  def list
    # Filtering articles
    conditions = "`contents`.id > 0"
    if params[:search]
      @search = params[:search]

      if @search[:published_at] and %r{(\d\d\d\d)-(\d\d)} =~ @search[:published_at]
        conditions += " AND published_at LIKE '%#{@search[:published_at]}%'"
      end

      if @search[:user_id] and @search[:user_id].to_i > 0
        conditions += " AND user_id = #{@search[:user_id].to_i}"
      end
      
      if @search[:published] and @search[:published].to_s =~ /0|1/
        conditions += " AND published = #{@search[:published].to_i}"
      end
      
      if @search[:category] and @search[:category].to_i > 0
        conditions += " AND categorizations.category_id = #{@search[:category].to_i}"
      end
      
    else
      @search = { :category => nil, :user_id => nil, :published_at => nil, :published => nil }
    end

    now = Time.now
    count = Article.count(:all, :include => :categorizations, :conditions => conditions)
    @articles_pages = Paginator.new(self, count, 20, params[:id])
    @articles = Article.find(:all, :limit => 20, :order => "contents.id DESC", :include => :categorizations, :conditions => conditions, :offset => @articles_pages.current.offset)
    setup_categories
    @article = Article.new(params[:article])
  end

  def show
    @article = Article.find(params[:id])
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
  alias_method :resource_add,    :category_add
  alias_method :resource_remove, :category_add

  def preview
    headers["Content-Type"] = "text/html; charset=utf-8"
    @article = Article.new
    @article.attributes = params[:article]
    set_article_author
    data = render_to_string(:layout => "minimal")
    data = Base64.encode64(data).gsub("\n", '')
    data = "data:text/html;charset=utf-8;base64,#{data}"
    render :text => data
  end

  def attachment_box_add
    render :update do |page|
      page["attachment_add_#{params[:id]}"].remove
      page.insert_html :bottom, 'attachments',
          :partial => 'admin/content/attachment',
          :locals => { :attachment_num => params[:id], :hidden => true }
      page.visual_effect(:toggle_appear, "attachment_#{params[:id]}")
    end
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
    params[:bookmarklet_link] && post_from_bookmarklet

    @resources = Resource.find(:all, :order => 'created_at DESC')
    @article.attributes = params[:article]
    setup_categories
    @selected = @article.categories.collect { |c| c.id }
    if request.post?
      set_article_author
      save_attachments
      if @article.save
        set_article_categories
        set_the_flash
        redirect_to :action => 'list'
      end
    end
  end

  def post_from_bookmarklet
    params[:article][:title] = params[:bookmarklet_title]
    params[:article][:body] = '<a href="' + params[:bookmarklet_link] + \
      ' title="' + params[:bookmarklet_title] + '">' + \
      params[:bookmarklet_title] + '</a>'
    params[:article][:body] += ("\n\n" + params[:bookmarklet_text]) if params[:bookmarklet_text]
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
    @article.author = current_user.login
    @article.user   = current_user
  end

  def save_attachments
    return if params[:attachments].nil?
    params[:attachments].each do |k,v|
      a = attachment_save(v)
      @article.resources << a unless a.nil?
    end
  end

  def set_article_categories
    @article.categorizations.clear
    if params[:categories]
      Category.find(params[:categories]).each do |cat|
        @article.categories << cat
      end
    end
    @selected = params[:categories] || []
  end

  def get_or_build_article
    @article = case params[:action]
               when 'new'
                 returning(Article.new) do |art|
                   art.allow_comments = this_blog.default_allow_comments
                   art.allow_pings    = this_blog.default_allow_pings
                   art.published      = true
                 end
               when 'edit'
                 Article.find(params[:id])
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
