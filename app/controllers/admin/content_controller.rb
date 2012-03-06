require 'base64'

module Admin; end
class Admin::ContentController < Admin::BaseController
  layout "administration", :except => [:show, :autosave]

  cache_sweeper :blog_sweeper

  def auto_complete_for_article_keywords
    @items = Tag.find_with_char params[:article][:keywords].strip
    render :inline => "<%= raw auto_complete_result @items, 'name' %>"
  end

  def index
    @search = params[:search] ? params[:search] : {}
    
    @articles = Article.search_with_pagination(@search, {:page => params[:page], :per_page => this_blog.admin_display_elements})

    if request.xhr?
      render :partial => 'article_list', :locals => { :articles => @articles }
    else
      @article = Article.new(params[:article])
    end
  end

  def new
    new_or_edit
  end

  def edit
    @article = Article.find(params[:id])
    unless @article.access_by? current_user
      redirect_to :action => 'index'
      flash[:error] = _("Error, you are not allowed to perform this action")
      return
    end
    new_or_edit
  end

  def destroy
    @record = Article.find(params[:id])

    unless @record.access_by?(current_user)
      flash[:error] = _("Error, you are not allowed to perform this action")
      return(redirect_to :action => 'index')
    end
    
    return(render 'admin/shared/destroy') unless request.post?

    @record.destroy
    flash[:notice] = _("This article was deleted successfully")
    redirect_to :action => 'index'
  end

  def insert_editor
    editor = 'visual'
    editor = 'simple' if params[:editor].to_s == 'simple'
    current_user.editor = editor
    current_user.save!

    render :partial => "#{editor}_editor"
  end

  def category_add; do_add_or_remove_fu; end
  alias_method :resource_add,    :category_add
  alias_method :resource_remove, :category_add

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
      Resource.create(:filename => attachment.original_filename, :mime => attachment.content_type.chomp, 
                      :created_at => Time.now).write_to_disk(attachment)
    rescue => e
      logger.info(e.message)
      nil
    end
  end

  def autosave
    id = params[:id]
    id = params[:article][:id] if params[:article] && params[:article][:id]
    @article = Article.get_or_build_article(id)
    @article.text_filter = current_user.text_filter if current_user.simple_editor?

    get_fresh_or_existing_draft_for_article
    
    @article.attributes = params[:article]
    @article.published = false
    set_article_author
    save_attachments

    set_article_title_for_autosave

    @article.state = "draft" unless @article.state == "withdrawn"
    if @article.save
      render(:update) do |page|
        page.replace_html('autosave', hidden_field_tag('article[id]', @article.id))
        page.replace_html('preview_link', link_to(_("Preview"), {:controller => '/articles', :action => 'preview', :id => @article.id}, {:target => 'new', :class => 'btn info'}))
        page.replace_html('destroy_link', link_to_destroy_draft(@article))
      end

      return true
    end
    render :text => nil
  end

  protected

  def get_fresh_or_existing_draft_for_article
    if @article.published and @article.id
      parent_id = @article.id
      @article = Article.drafts.child_of(parent_id).first || Article.new
      @article.allow_comments = this_blog.default_allow_comments
      @article.allow_pings    = this_blog.default_allow_pings
      @article.parent_id      = parent_id
    end
  end

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
    id = params[:id]
    id = params[:article][:id] if params[:article] && params[:article][:id]
    @article = Article.get_or_build_article(id)
    @article.text_filter = current_user.text_filter if current_user.simple_editor?

    @post_types = PostType.find(:all)
    if request.post?
      if params[:article][:draft]
        get_fresh_or_existing_draft_for_article
      else
        if not @article.parent_id.nil?
          @article = Article.find(@article.parent_id)
        end
      end
    end

    @article.keywords = Tag.collection_to_string @article.tags
    @article.attributes = params[:article]
    # TODO: Consider refactoring, because double rescue looks... weird.
        
    @article.published_at = DateTime.strptime(params[:article][:published_at], "%B %e, %Y %I:%M %p GMT%z").utc rescue Time.parse(params[:article][:published_at]).utc rescue nil

    if request.post?
      set_article_author
      save_attachments
      
      @article.state = "draft" if @article.draft

      if @article.save
        destroy_the_draft unless @article.draft
        set_article_categories
        set_the_flash
        redirect_to :action => 'index'
        return
      end
    end

    @images = Resource.images_by_created_at.page(params[:page]).per(10)
    @resources = Resource.without_images_by_filename
    @macros = TextFilter.macro_filters
    render 'new'
  end

  def set_the_flash
    case params[:action]
    when 'new'
      flash[:notice] = _('Article was successfully created')
    when 'edit'
      flash[:notice] = _('Article was successfully updated.')
    else
      raise "I don't know how to tidy up action: #{params[:action]}"
    end
  end

  def destroy_the_draft
    Article.all(:conditions => { :parent_id => @article.id }).map(&:destroy)
  end

  def set_article_author
    return if @article.author
    @article.author = current_user.login
    @article.user   = current_user
  end

  def set_article_title_for_autosave
    if @article.title.blank?
      lastid = Article.find(:first, :order => 'id DESC').id
      @article.title = "Draft article " + lastid.to_s
    end
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
  end

  def def_build_body
    if @article.body =~ /<!--more-->/
      body = @article.body.split('<!--more-->')
      @article.body = body[0]
      @article.extended = body[1]
    end

  end

  def setup_resources
    @resources = Resource.by_created_at
  end
end
