# frozen_string_literal: true

class FeedbackController < BaseController
  def index
    @feedback = Feedback.ham.
      newest_first.
      limit(this_blog.per_page(params[:format]))
    respond_to do |format|
      format.atom { render "index", format: "atom" }
      format.rss { render "index", format: "rss" }
    end
  end
end
