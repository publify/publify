class Admin::FeedbackController < Admin::BaseController
  def index
    conditions = ["(contents.type = 'Comment' or contents.type = 'Trackback')"]

    if params[:search]
      search_sql = "%#{params[:search]}%"
      conditions.first << ' and (url like ? or author like ? or title like ? or ip like ? or email like ?)'
      5.times { conditions.push search_sql }
    end

    if params[:published] == 'f'
      conditions.first << ' and (published = ?)'
      conditions.push false
    end

    @pages, @feedback = paginate(:contents, 
      :order => 'contents.created_at desc', 
      :conditions => conditions,
      :per_page => 40)
    
    render_action 'list'
  end
  
  def delete
    if request.post?
      feedback = Content.find(params[:id])
      if feedback.kind_of? Comment or feedback.kind_of? Trackback
        feedback.destroy
        flash[:notice] = "Deleted"
      else
        flash[:notice] = "Not found"
      end
    end
    redirect_to :action => 'index', :page => params[:page], :search => params[:search]
  end
  
  def bulkops
    STDERR.puts "Bulkops: #{params.inspect}"
    
    ids = (params[:feedback_check]||{}).keys.map(&:to_i)
    
    case params[:commit]
    when 'Delete Checked Items'
      count = 0
      ids.each do |id|
        count += Content.delete(id)
      end
      flash[:notice] = "Deleted #{count} item(s)"
    when 'Publish Checked Items'
      ids.each do |id|
        feedback = Content.find(id)
        feedback.attributes[:published] = true
        feedback.save
      end
      flash[:notice]= "Published #{ids.size} item(s)"
    when 'Unpublish Checked Items'
      ids.each do |id|
        feedback = Content.find(id)
        feedback.withdraw!
        feedback.save
      end
      flash[:notice]= "Unpublished #{ids.size} item(s)"
    else
      flash[:notice] = "Not implemented"
    end

    redirect_to :action => 'index', :page => params[:page], :search => params[:search]
  end
end
