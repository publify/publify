# frozen_string_literal: true

class PublifyTextileToMarkdown
  class << self
    def convert
      Content.find_each do |content|
        convert_item(content)
      end

      Feedback.find_each do |feedback|
        convert_item(feedback)
      end
    end

    private

    def convert_item(item)
      item.text_filter_name == "textile" or return

      fields = item.content_fields
      fields.each do |field|
        html = item.html(field)
        item.send "#{field}=", ReverseMarkdown.convert(html)
      end
      item.text_filter_name = "markdown"
      item.save!
    end
  end
end
