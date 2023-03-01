# frozen_string_literal: true

class TagSidebar < SidebarConfiguration
  display_name "Tags"
  description "Show most popular tags for this blog"

  setting :maximum_tags, 20

  def tags
    @tags ||= Tag.find_all_with_content_counters.
      take(maximum_tags.to_i).sort_by(&:name)
  end

  def sizes
    return @sizes if @sizes

    total = tags.reduce(0) { |sum, tag| sum + tag.content_counter }
    average = total.to_f / @tags.size
    @sizes = tags.reduce({}) do |h, tag|
      size = tag.content_counter.to_f / average
      h.merge tag => [[2.0 / 3.0, size].max, 2].min * 100
    end
  end

  def font_multiplier
    80
  end
end

SidebarRegistry.register_sidebar TagSidebar
