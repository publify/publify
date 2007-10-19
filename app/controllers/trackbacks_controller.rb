class TrackbacksController < FeedbackController
  def create
    @error_message = catch(:error) do
      if this_blog.global_pings_disable
        throw :error, "Trackback not saved"
      elsif params[:__mode] == 'rss'
        # Part of the trackback spec... not sure what we should be doing here though.
      else
          @trackback = \
            this_blog.ping_article! \
              params.merge(:ip => request.remote_ip,
                           :published => true)
      end
    end
  rescue ActiveRecord::RecordNotFound, ActiveRecord::StatementInvalid
    @error_message = "Article id #{params[:id]} not found."
  rescue ActiveRecord::RecordInvalid
    @error_message = "Trackback not saved"
  end

  protected

  def get_feedback
    @trackbacks =
      if params[:article_id]
        this_blog.requested_article(params).published_trackbacks
      else
        this_blog.published_trackbacks.with_options(this_blog.rss_limit_params) do |t|
          t.find(:all, :order => 'created_at DESC')
        end
      end
  end

  def get_article
    true
  end
end
