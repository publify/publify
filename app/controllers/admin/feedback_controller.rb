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
      :per_page => 20)
    
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
    redirect_to :action => 'index'
  end
end
