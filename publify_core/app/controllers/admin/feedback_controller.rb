# frozen_string_literal: true

class Admin::FeedbackController < Admin::BaseController
  ONLY_DOMAIN = %w(unapproved presumed_ham presumed_spam ham spam).freeze

  def index
    scoped_feedback = this_blog.feedback

    if params[:only].present?
      @only_param = ONLY_DOMAIN.dup.delete(params[:only])
      scoped_feedback = scoped_feedback.send(@only_param) if @only_param
    end

    params.delete(:page) if params[:page].blank? || params[:page] == '0'

    @feedback = scoped_feedback.paginated(params[:page], this_blog.admin_display_elements)
  end

  def destroy
    @record = Feedback.find params[:id]

    unless @record.article.user_id == current_user.id
      return redirect_to admin_feedback_index_url unless current_user.admin?
    end

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
    @comment = @article.comments.build(comment_params)
    @comment.user_id = current_user.id

    if request.post? && @comment.save
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
      redirect_to admin_feedback_index_url
      return
    end
  end

  def update
    comment = Comment.find(params[:id])
    unless comment.article.access_by? current_user
      redirect_to admin_feedback_index_url
      return
    end
    comment.attributes = comment_params
    if request.post? && comment.save
      flash[:success] = I18n.t('admin.feedback.update.success')
      redirect_to action: 'article', id: comment.article.id
    else
      redirect_to action: 'edit', id: comment.id
    end
  end

  def article
    @article = this_blog.articles.find(params[:id])
    @feedback = @article.comments
    @feedback = @feedback.ham if params[:ham] && params[:spam].blank?
    @feedback = @feedback.spam if params[:spam] && params[:ham].blank?
  end

  # TODO: Replace with actions that move to a specified state
  def change_state
    return unless request.xhr?

    @feedback = Feedback.find(params[:id])
    template = @feedback.change_state!

    respond_to do |format|
      # TODO: Make this special case not necessary
      if params[:context] != 'listing'
        @comments = Comment.last_published
        page.replace_html('commentList', partial: 'admin/dashboard/comment')
      elsif template == 'ham'
        format.js { render 'ham' }
      else
        format.js { render 'spam' }
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
    when 'Mark Checked Items as Ham'
      update_feedback(items, :mark_as_ham!)
      flash[:success] = I18n.t('admin.feedback.bulkops.success_mark_as_ham', count: ids.size)
    when 'Mark Checked Items as Spam'
      update_feedback(items, :mark_as_spam!)
      flash[:success] = I18n.t('admin.feedback.bulkops.success_mark_as_spam', count: ids.size)
    when 'Confirm Classification of Checked Items'
      update_feedback(items, :confirm_classification!)
      flash[:success] = I18n.t('admin.feedback.bulkops.success_classification', count: ids.size)
    when 'Delete all spam'
      if request.post?
        Feedback.where('state = ?', 'spam').delete_all
        flash[:success] = I18n.t('admin.feedback.bulkops.success_deleted_spam')
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

  private

  def comment_params
    params.require(:comment).permit(:author, :email, :url, :body)
  end

  def update_feedback(items, method)
    items.each do |value|
      value.send(method)
    end
  end
end
