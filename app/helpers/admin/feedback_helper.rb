module Admin::FeedbackHelper
  def comment_class state
    (state.to_s =~ /Ham/) ? 'published' : 'unpublished'
#    if state.to_s == "Ham?" or state.to_s == "Ham"
#      return 'published'
#    end
#    'unpublished'
  end
end
