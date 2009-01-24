module Admin::FeedbackHelper
  def comment_class state
    (state.to_s =~ /Ham/) ? 'published' : 'unpublished'
  end
end
