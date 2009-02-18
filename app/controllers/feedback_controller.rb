class FeedbackController < ApplicationController
  helper :theme

  session :new_session => false
  before_filter :get_article, :only => [:create, :update]

  cache_sweeper :blog_sweeper

  # Used only by comments. Maybe need move to comments controller
  # or use it in our code with send some feed about trackback
  def index
    @page_title = self.class.name.to_s.sub(/Controller$/, '')
    respond_to do |format|
      format.html do
        if params[:article_id]
          article = Article.find(params[:article_id])
          redirect_to "#{article.permalink_url}\##{@page_title.underscore}"
        else
          render :text => 'this space left blank'
        end
      end
      format.atom { render :partial => 'articles/atom_feed', :object => get_feedback }
      format.rss { render :partial => 'articles/rss20_feed', :object => get_feedback }
    end
  end

  protected

  def get_article
    @article = this_blog.requested_article(params)
  end

  def get_feedback
    if params[:article_id]
      Article.find(params[:article_id]).published_feedback
    else
      this_blog.published_feedback.find(:all, this_blog.rss_limit_params.merge(:order => 'created_at DESC'))
    end
  end
end
