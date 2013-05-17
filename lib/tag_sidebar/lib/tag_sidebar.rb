class TagSidebar < Sidebar
  display_name "Tags"
  description "Show most popular tags for this blog"

  setting :maximum_tags, 20

  def tags
    @tags ||= Tag.find_all_with_article_counters(maximum_tags.to_i).sort_by {|t| t.name}
  end

  def sizes
    return @sizes if @sizes
    total = @tags.inject(0) {|total, tag| total + tag.article_counter }
    average = total.to_f / @tags.size.to_f
    @sizes = @tags.inject({}) do |h,tag|
      size = tag.article_counter.to_f / average
      h.merge tag => [[2.0/3.0, size].max, 2].min * 100
    end
  end

  def font_multiplier
    80
  end
end
