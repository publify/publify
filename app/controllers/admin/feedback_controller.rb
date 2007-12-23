require 'comment'
require 'trackback'

class Admin::FeedbackController < Admin::BaseController

  def index
    conditions = ['blog_id = :blog_id', {:blog_id => Blog.default.id}]

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

    @pages, @feedback = paginate(:feedback,
      :order => 'feedback.created_at desc',
      :conditions => conditions,
      :per_page => 40)

    render :action => 'list'
  end

  def delete
    if request.post?
      begin
        Feedback.destroy(params[:id])
        flash[:notice] = "Deleted"
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = "Not found"
      end
    end
    redirect_to :action => 'index', :page => params[:page], :search => params[:search]
  end

  def bulkops
    ids = (params[:feedback_check]||{}).keys.map(&:to_i)
    items = Feedback.find(ids)
    @unexpired = true

    case params[:commit]
    when 'Delete Checked Items'
      count = 0
      ids.each do |id|
        count += Feedback.delete(id) ## XXX Should this be #destroy?
      end
      flash[:notice] = "Deleted #{count} item(s)"

      items.each do |i|
        i.invalidates_cache? or next
        flush_cache
        return
      end
    when 'Mark Checked Items as Ham'
      update_feedback(items, :mark_as_ham!)
      flash[:notice]= "Marked #{ids.size} item(s) as Ham"
    when 'Mark Checked Items as Spam'
      update_feedback(items, :mark_as_spam!)
      flash[:notice]= "Marked #{ids.size} item(s) as Spam"
    when 'Confirm Classification of Checked Items'
      update_feedback(items, :confirm_classification!)
      flash[:notice] = "Confirmed classification of #{ids.size} item(s)"
    else
      flash[:notice] = "Not implemented"
    end

    redirect_to :action => 'index', :page => params[:page], :search => params[:search], :confirmed => params[:confirmed], :published => params[:published]
  end

  protected

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
    expire_fragment(/.*/)
  end
end
