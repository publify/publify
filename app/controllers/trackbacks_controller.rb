class TrackbacksController < FeedbackController
  def create
    @error_message = catch(:error) do
      if this_blog.global_pings_disable
        throw :error, "Trackback not saved"
      elsif params[:__mode] == 'rss'
        # Part of the trackback spec... not sure what we should be doing here though.
      else
          begin
              @trackback =  this_blog.ping_article!(
                params.merge(:ip => request.remote_ip, :published => true))
              ""
          rescue ActiveRecord::RecordNotFound, ActiveRecord::StatementInvalid
            throw :error, "Article id #{params[:id]} not found."
          rescue ActiveRecord::RecordInvalid
            throw :error, "Trackback not saved"
          end
      end
    end

    respond_to do |format|
      format.xml { render 'trackback.xml.builder' }
      format.html { render :nothing => true }
    end
  end

  protected

  def get_feedback
    @trackbacks =
      if params[:article_id]
        Article.find(params[:article_id]).published_trackbacks
      else
        Trackback.find_published(:all, this_blog.rss_limit_params.merge(:order => 'created_at DESC'))
      end
  end

  def get_article
    true
  end
end
