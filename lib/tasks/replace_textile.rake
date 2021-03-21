# frozen_string_literal: true

require "publify_textile_to_markdown"

namespace :publify do
  desc "Convert content in Textile format to Markdown"
  task textile_to_markdown: :environment do
    PublifyTextileToMarkdown.convert
  end
end
