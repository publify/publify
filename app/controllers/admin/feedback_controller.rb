class Admin::FeedbackController < Admin::BaseController

  cache_sweeper :blog_sweeper
  before_filter :only_own_feedback, :only => [:delete]

  def index
    conditions = ['1 = 1', {}]

    if params[:search]
      conditions.first << ' and (url like :pattern or author like :pattern or title like :pattern or ip like :pattern or email like :pattern)'
      conditions.last.merge!(:pattern => "%#{params[:search]}%")
    end

    if params[:published] == 'f'
      conditions.first << ' and (published = :published)'
      conditions.last.merge!(:published => false)
    end

    if params[:confirmed] == 'f'
      conditions.first << ' AND (status_confirmed = :status_confirmed)'
      conditions.last.merge!(:status_confirmed => false)
    end

    if params[:ham] == 'f'
      conditions.first << ' AND state = :state '
      conditions.last.merge!(:state => 'ham')
    end

    # no need params[:page] if empty of == 0, there are a crash otherwise
    if params[:page].blank? || params[:page] == "0"
      params.delete(:page)
    end

    @feedback = Feedback.paginate :page => params[:page], :order => 'feedback.created_at desc', :conditions => conditions, :per_page => this_blog.admin_display_elements
  end

  def article
    @article = Article.find(params[:id])
    if params[:ham] && params[:spam].blank?
      @comments = @article.comments.ham
    end
    if params[:spam] && params[:ham].blank?
      @comments = @article.comments.spam
    end
    @comments ||= @article.comments
  end
  
  def delete
    if request.post?
      begin
        @feedback.destroy
        flash[:notice] = _("Deleted")
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = _("Not found")
      end
    end
    redirect_to :action => 'article', :id => @feedback.article.id
  end

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(params[:comment])
    @comment.user_id = current_user.id
    
    if request.post? and @comment.save
      # We should probably wave a spam filter over this, but for now, just mark it as published.
      @comment.mark_as_ham!
      flash[:notice] = _('Comment was successfully created.')
    end
    redirect_to :action => 'article', :id => @article.id
  end

  def edit
    @comment = Comment.find(params[:id])
    @article = @comment.article
    unless @article.access_by? current_user
      redirect_to :action => 'index'
      return
    end
  end

  def update
    comment = Comment.find(params[:id])
    unless comment.article.access_by? current_user
      redirect_to :action => 'index'
      return
    end
    comment.attributes = params[:comment]
    if request.post? and comment.save
      flash[:notice] = _('Comment was successfully updated.')
      redirect_to :action => 'article', :id => comment.article.id
    else
      redirect_to :action => 'edit', :id => comment.id
    end
  end

  def preview
    feedback = Feedback.find(params[:id])
    render(:update) do |page|
      page.replace_html("feedback_#{feedback.id}", feedback.body)
    end
    
  end

  def bulkops
    ids = (params[:feedback_check]||{}).keys.map(&:to_i)
    items = Feedback.find(ids)
    @unexpired = true

    bulkop = params[:bulkop_top].empty? ? params[:bulkop_bottom] : params[:bulkop_top]
    case bulkop
    when 'Delete Checked Items'
      count = 0
      ids.each do |id|
        count += Feedback.delete(id) ## XXX Should this be #destroy?
      end
      flash[:notice] = _("Deleted %d item(s)",count)

      items.each do |i|
        i.invalidates_cache? or next
        flush_cache
        return
      end
    when 'Mark Checked Items as Ham'
      update_feedback(items, :mark_as_ham!)
      flash[:notice]= _("Marked %d item(s) as Ham",ids.size)
    when 'Mark Checked Items as Spam'
      update_feedback(items, :mark_as_spam!)
      flash[:notice]= _("Marked %d item(s) as Spam",ids.size)
    when 'Confirm Classification of Checked Items'
      update_feedback(items, :confirm_classification!)
      flash[:notice] = _("Confirmed classification of %s item(s)",ids.size)
    when 'Delete all spam'
      delete_all_spam
    else
      flash[:notice] = _("Not implemented")
    end

    redirect_to :action => 'index', :page => params[:page], :search => params[:search], :confirmed => params[:confirmed], :published => params[:published]
  end

  protected

  def delete_all_spam
    if request.post?
      Feedback.delete_all(['state in (?,?)', "presumed_spam", "spam"])
      flash[:notice] = _("All spam have been deleted")
    end
  end

  def update_feedback(items, method)
    items.each do |value|
      value.send(method)
      @unexpired && value.invalidates_cache? or next
      flush_cache
    end
  end

  def flush_cache
    @unexpired = false
    PageCache.sweep_all
  end

  def only_own_feedback
    @feedback = Feedback.find(params[:id])
    unless @feedback.article.user_id == current_user.id
      unless current_user.admin?
        redirect_to :controller => 'admin/feedback', :action => :index
      end
    end
  end

end
