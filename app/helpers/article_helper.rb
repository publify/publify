module ArticleHelper

  def display_comment_timestamp(comment)
    if comment.created_at > 24.hours.ago
      time_ago_in_words(comment.created_at) + ' ago'
    else
      if comment.created_at.year == Date.today.year
        comment.created_at.strftime('%e %B')
      else
        comment.created_at.strftime('%e %B %Y')
      end
    end
  end
end
