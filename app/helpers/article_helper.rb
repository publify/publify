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

  def report_comment_link(comment)
    mail_to ENV['REPORT_COMMENT_EMAIL_ADDRESS'],
            t('.report_comment'),
            subject: "Reported comment in article '#{comment.article.title}'",
            body: report_comment_email_template(comment)
  end

  private

  def report_comment_email_template(comment)
    <<-EOS
      Reported comment: #{comment.article.permalink_url + "#comment-#{comment.id}"}

      Please enter any further notes below:
    EOS
  end
end
