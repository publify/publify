class FeedbackController < ApplicationController
  helper :theme

  session :new_session => false
  before_filter :login_required, :only => [:update, :destroy]
  before_filter :get_article, :only => [:create, :update]

  cache_sweeper :blog_sweeper

  def index
    @page_title = self.class.name.to_s.sub(/Controller$/, '')
    respond_to do |format|
      format.html do
        if params[:article_id]
          article = this_blog.requested_article(params)
          redirect_to "#{article_path(article)}\##{@page_title.underscore}"
        else
          render :text => 'this space left blank'
        end
      end
      format.atom { render :partial => 'articles/atom_feed', :object => get_feedback }
      format.rss { render :partial => 'articles/rss20_feed', :object => get_feedback }
    end
  end

  def create
    raise "Subclass responsibility"
  end

  def update
    raise "Subclass responsibility"
  end

  def destroy
    fb = Feedback.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to article_path(article) }
      format.js do
        render :update do |page|
          page.visual_effect(:puff, "#{fb.class.to_s.underscore}-#{fb.id}")
        end
      end
    end
  end

  protected

  def get_article
    @article = this_blog.requested_article(params)
  end

  def get_feedback
    if params[:article_id]
      this_blog.requested_article(params).published_feedback
    else
      this_blog.published_feedback.find(:all, this_blog.rss_limit_params.merge(:order => 'created_at DESC'))
    end
  end
end
