class FeedbackController < ApplicationController
  helper :theme

  before_action :get_article, only: [:create]

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
          redirect_to "#{URI.parse(article.permalink_url).path}\##{@page_title.underscore}"
        else
          render text: 'this space left blank'
        end
      end
      feedbacks = Feedback.from(controller_name, params[:article_id]).limit(this_blog.per_page(params[:format]))
      format.atom { render_feed 'atom', feedbacks }
      format.rss { render_feed 'rss', feedbacks }
    end
  end

  protected

  def render_feed(format, collection)
    ivar_name = "@#{self.class.to_s.sub(/Controller$/, '').underscore}"
    instance_variable_set(ivar_name, collection)
    render "index_#{format}_feed"
  end
end
