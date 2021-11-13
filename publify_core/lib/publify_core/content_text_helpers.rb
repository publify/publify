# frozen_string_literal: true

require "rails_autolink/helpers"

module PublifyCore
  class ContentTextHelpers
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::SanitizeHelper
  end
end
