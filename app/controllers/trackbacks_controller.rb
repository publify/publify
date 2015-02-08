class TrackbacksController < FeedbackController
  def create
    @error_message = catch(:error) do
      if this_blog.global_pings_disable
        throw :error, 'Trackback not saved'
      elsif params[:__mode] == 'rss'
        # Part of the trackback spec... not sure what we should be doing here though.
      else
        begin
          @trackback =  this_blog.ping_article!(
            params.merge(ip: request.remote_ip, published: true))
          ''
      rescue ActiveRecord::RecordNotFound, ActiveRecord::StatementInvalid
        throw :error, "Article id #{params[:id]} not found."
      rescue ActiveRecord::RecordInvalid
        throw :error, 'Trackback not saved'
        end
      end
    end

    respond_to do |format|
      format.xml { render 'trackback', formats: [:xml], handlers: [:builder] }
      format.html { render nothing: true }
    end
  end

  protected

  def get_article
    true
  end
end
