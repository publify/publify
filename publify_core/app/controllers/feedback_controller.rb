class FeedbackController < BaseController
  def index
    feedbacks = Feedback.
      from(controller_name, params[:article_id]).
      limit(this_blog.per_page(params[:format]))
    respond_to do |format|
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
