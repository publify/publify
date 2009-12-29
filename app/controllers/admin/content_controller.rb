require 'base64'

module Admin; end
class Admin::ContentController < Admin::BaseController
  layout "administration", :except => [:show, :autosave]

  cache_sweeper :blog_sweeper

  def auto_complete_for_article_keywords
    @items = Tag.find_with_char params[:article][:keywords].strip
    render :inline => "<%= auto_complete_result @items, 'name' %>"
  end

  def index
    @search = params[:search] ? params[:search] : {}
    @articles = Article.search_no_draft_paginate(@search, :page => params[:page], :per_page => this_blog.admin_display_elements)

    if request.xhr?
      render :partial => 'article_list', :object => @articles
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
    @article = Article.find(params[:id])

    unless @article.access_by?(current_user)
      redirect_to :action => 'index'
      flash[:error] = _("Error, you are not allowed to perform this action")
      return
    end

    if request.post?
      @article.destroy
      redirect_to :action => 'index'
      return
    end
  end

  def insert_editor
    return unless params[:editor].to_s =~ /simple|visual/
    current_user.editor = params[:editor].to_s
    current_user.save!

    render :partial => "#{params[:editor].to_s}_editor"
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
      Resource.create(:filename => attachment.original_filename,
                      :mime => attachment.content_type.chomp, :created_at => Time.now).write_to_disk(attachment)
    rescue => e
      logger.info(e.message)
      nil
    end
  end

  def autosave
    get_or_build_article

    # This is ugly, but I have to check whether or not the article is
    # published to create the dummy draft I'll replace later so that the
    # published article doesn't get overriden on the front
    if @article.published
      parent_id = @article.id
      @article = Article.drafts.child_of(parent_id).first || Article.new
      @article.allow_comments = this_blog.default_allow_comments
      @article.allow_pings    = this_blog.default_allow_pings
      @article.text_filter    = (current_user.editor == 'simple') ? current_user.text_filter : 1
      @article.parent_id      = parent_id
    end

    params[:article] ||= {}
    @article.attributes = params[:article]
    @article.published = false
    set_article_author
    save_attachments

    set_article_title_for_autosave

    @article.state = "draft" unless @article.state == "withdrawn"
    if @article.save
      render(:update) do |page|
        page.replace_html('autosave', hidden_field_tag('id', @article.id))
        page.replace_html('permalink', text_field('article', 'permalink', {:class => 'small medium'}))
        page.replace_html('preview_link', link_to(_("Preview"), {:controller => '/previews', :id => @article.id }, {:target => 'new'}))
      end

      return true
    end
    render :text => nil
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

    @macros = TextFilter.available_filters.select { |filter| TextFilterPlugin::Macro > filter }
    @article.published = true

    # TODO Test if we can delete the next line. It's delete on nice_permalinks branch
    params[:article] ||= {}

    @resources = Resource.find(:all, :order => 'filename')
    @images = Resource.paginate :page => params[:page], :conditions => "mime LIKE '%image%'", :order => 'created_at DESC', :per_page => 10
    @article.attributes = params[:article]


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
    render :action => 'new'
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
    unless @article.parent_id and Article.find(@article.parent_id).published
      @article.permalink = @article.stripped_title
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

  def get_or_build_article
    @article = case params[:id]
             when nil
               returning(Article.new) do |art|
                 art.allow_comments = this_blog.default_allow_comments
                 art.allow_pings    = this_blog.default_allow_pings
                 art.text_filter    = (current_user.editor == 'simple') ? current_user.text_filter : 1
               end
            else
              Article.find(params[:id])
            end
  end

  def setup_resources
    @resources = Resource.find(:all, :order => 'created_at DESC')
  end
end
