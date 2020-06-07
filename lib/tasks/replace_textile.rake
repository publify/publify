# frozen_string_literal: true

namespace :publify do
  desc "Convert content in Textile format to Markdown"
  task textile_to_markdown: :environment do
    Content.find_each do |content|
      content.text_filter_name == "textile" or next

      body_html = content.html(:body)
      content.body = ReverseMarkdown.convert body_html
      extended_html = content.html(:extended)
      content.extended = ReverseMarkdown.convert extended_html
      content.text_filter_name = "markdown"
      content.save!
    end

    Feedback.find_each do |feedback|
      feedback.text_filter_name == "textile" or next

      body_html = feedback.html(:body)
      feedback.body = ReverseMarkdown.convert body_html
      extended_html = feedback.html(:extended)
      feedback.extended = ReverseMarkdown.convert extended_html
      feedback.text_filter_name = "markdown"
      feedback.save!
    end
  end
end
