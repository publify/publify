class TrackbacksController < ApplicationController
  helper :theme

  session :new_session => false

  cache_sweeper :blog_sweeper

  def index
    article = nil
    if params[:article_id]
      article = this_blog.requested_article(params)
      @trackbacks = article.published_trackbacks
    else
      this_blog.with_options(this_blog.rss_limit_params) do |b|
        @comments = b.published_trackbacks(:order => 'created_at DESC')
      end
    end

    @page_title = "Comments"
    respond_to do |format|
      format.html do
        if article
          redirect_to "#{article_path(article)}\#trackbacks"
        else
          render :text => 'this space left blank'
        end
      end
      format.atom { render :partial => 'articles/atom_feed', :object => @comments }
      format.rss { render :partial => 'articles/rss20_feed', :object => @comments }
    end
  end

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
  
end