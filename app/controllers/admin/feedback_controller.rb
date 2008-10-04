require 'comment'
require 'trackback'

class Admin::FeedbackController < Admin::BaseController

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

    @pages, @feedback = paginate(:feedback,
      :order => 'feedback.created_at desc',
      :conditions => conditions,
      :per_page => 40)

  end

  def delete
    if request.post?
      begin
        Feedback.destroy(params[:id])
        flash[:notice] = _("Deleted")
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = _("Not found")
      end
    end
    redirect_to :action => 'index', :page => params[:page], :search => params[:search]
  end

  def bulkops
    ids = (params[:feedback_check]||{}).keys.map(&:to_i)
    items = Feedback.find(ids)
    @unexpired = true

    case params[:bulkop]
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
    else
      flash[:notice] = _("Not implemented")
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
