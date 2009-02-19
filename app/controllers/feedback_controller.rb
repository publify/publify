class FeedbackController < ApplicationController
  helper :theme

  session :new_session => false
  before_filter :get_article, :only => [:create]

  cache_sweeper :blog_sweeper

  # Used only by comments. Maybe need move to comments controller
  # or use it in our code with send some feed about trackback
  #
  # Redirect to article with good anchor with /comments?article_id=xxx ou
  # /trackacks?article_id=xxx
  #
  # If no article_id params, so no page found. TODO: See all
  # comments/trackbacks with paginate ?
  #
  # If /comments.rss|atom or /trabacks.atom|rss see a feed about all comments
  # or trackback
  #
  # If article_id params in feed see only this comment|feedback on this
  # article.
  #
  # TODO: It's usefull but use anywhere. Create some extension in xml_sidebar
  # to define this feed.
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

  def get_feedback
    if params[:article_id]
      Article.find(params[:article_id]).published_feedback
    else
      this_blog.published_feedback.find(:all, this_blog.rss_limit_params.merge(:order => 'created_at DESC'))
    end
  end
end
