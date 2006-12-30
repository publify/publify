module Admin::ContentHelper
  include ArticlesHelper
  include ActionView::Helpers::DateHelper

  def contents
    [@article]
  end

  def time_delta_from_now_in_words(timestamp)
    distance_of_time_in_words_to_now(timestamp) + ((Time.now < timestamp) ? ' from now' : ' ago')
  end
end
