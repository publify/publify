class Admin::FeedbackController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index
    if params[:article_id]
      @article = Article.find(params[:article_id])
      scoped_feedback = @article.comments
    else
      scoped_feedback = Feedback
    end

    scoped_feedback = scoped_feedback.unscope(:order)

    if params[:only].present?
      scoped_feedback = scoped_feedback.send(params[:only])
    end

    if params[:sort_by].present? && params[:sort_by] == 'commenter'
      if params[:sort_order].present? && params[:sort_order] == 'desc'
        scoped_feedback = scoped_feedback.order('author DESC')
      else
        scoped_feedback = scoped_feedback.order('author ASC')
      end
    else
      if params[:sort_order].present? && params[:sort_order] == 'desc'
        scoped_feedback = scoped_feedback.order('created_at DESC')
      else
        scoped_feedback = scoped_feedback.order('created_at ASC')
      end
    end

    if params[:page].blank? || params[:page] == '0'
      params.delete(:page)
    end

    @feedback = scoped_feedback.paginated(params[:page], this_blog.admin_display_elements)
  end

  def destroy
    @record = Feedback.find params[:id]

    unless @record.article.user_id == current_user.id
      unless current_user.admin?
        return redirect_to controller: 'admin/feedback', action: :index
      end
    end

    return(render 'admin/shared/destroy') unless request.post?

    begin
      @record.destroy
      flash[:success] = I18n.t('admin.feedback.destroy.success')
    rescue ActiveRecord::RecordNotFound
      flash[:error] = I18n.t('admin.feedback.destroy.error')
    end
    redirect_to action: 'article', id: @record.article.id
  end

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(params[:comment].permit!)
    @comment.user_id = current_user.id

    if request.post? and @comment.save
      # We should probably wave a spam filter over this, but for now, just mark it as published.
      @comment.mark_as_ham
      @comment.save!
      flash[:success] = I18n.t('admin.feedback.create.success')
    end
    redirect_to action: 'article', id: @article.id
  end

  def edit
    @comment = Comment.find(params[:id])
    @article = @comment.article
    unless @article.access_by? current_user
      redirect_to action: 'index'
      return
    end
  end

  def update
    comment = Comment.find(params[:id])
    unless comment.article.access_by? current_user
      redirect_to action: 'index'
      return
    end
    comment.attributes = params[:comment].permit!
    if request.post? and comment.save
      flash[:success] = I18n.t('admin.feedback.update.success')
      redirect_to action: 'article', id: comment.article.id
    else
      redirect_to action: 'edit', id: comment.id
    end
  end

  def change_state
    return unless request.xhr?

    @feedback = Feedback.find(params[:id])
    template = @feedback.change_state!

    respond_to do |format|

      if params[:context] != 'listing'
        @comments = Comment.last_published
        page.replace_html('commentList', partial: 'admin/dashboard/comment')
      else
        if template == 'ham'
          format.js { render 'ham' }
        else
          format.js { render 'spam' }
        end
      end
    end
  end

  def bulkops
    ids = (params[:feedback_check] || {}).keys.map(&:to_i)
    items = Feedback.find(ids)
    @unexpired = true

    bulkop = (params[:bulkop_top] || {}).empty? ? params[:bulkop_bottom] : params[:bulkop_top]

    case bulkop
    when 'Delete Checked Items'
      count = 0
      ids.each do |id|
        count += Feedback.delete(id)
      end
      flash[:success] = I18n.t('admin.feedback.bulkops.success_deleted', count: count)

      items.each do |i|
        i.invalidates_cache? or next
        flush_cache
        return
      end
    when 'Mark Checked Items as Ham'
      update_feedback(items, :mark_as_ham!)
      flash[:success] =  I18n.t('admin.feedback.bulkops.success_mark_as_ham', count: ids.size)
    when 'Mark Checked Items as Spam'
      update_feedback(items, :mark_as_spam!)
      flash[:success] =  I18n.t('admin.feedback.bulkops.success_mark_as_spam', count: ids.size)
    when 'Confirm Classification of Checked Items'
      update_feedback(items, :confirm_classification!)
      flash[:success] = I18n.t('admin.feedback.bulkops.success_classification', count: ids.size)
    when 'Delete all spam'
      if request.post?
        Feedback.delete_all(['state = ?', 'spam'])
        flash[:success] = I18n.t('admin.feedback.bulkops.success')
      end
    else
      flash[:error] = I18n.t('admin.feedback.bulkops.error')
    end

    if params[:article_id]
      redirect_to action: 'article', id: params[:article_id], confirmed: params[:confirmed], published: params[:published]
    else
      redirect_to action: 'index', page: params[:page], search: params[:search], confirmed: params[:confirmed], published: params[:published]
    end
  end

  protected

  def sort_order
    if params[:sort_by].present? && params[:sort_by] == 'commenter'
      'commenter'
    else
      'commented_at'
    end
  end

  def sort_by
    if params[:sort_order].present?
      if params[:sort_by]
        params[:sort_by]
      else

    else
      'commented_at'
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

end
