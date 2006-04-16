class Plugins::Sidebars::TagController < Sidebars::ComponentPlugin
  model :tag

  display_name "Tags"
  description "Show most popular tags for this blog"

  setting :maximum_tags, 20

  def content
    @tags = Tag.find_all_with_article_counters(maximum_tags.to_i).sort_by {|t| t.name}
    total=@tags.inject(0) {|total,tag| total += tag.article_counter }
    average = total.to_f / @tags.size.to_f
    @sizes = @tags.inject({}) {|h,tag| h[tag] = (tag.article_counter.to_f / average); h} # create a percentage
    # apply a lower limit of 50% and an upper limit of 200%
    @sizes.each {|tag,size| @sizes[tag] = [[2.0/3.0, size].max, 2].min * 100}
    @font_multiplier = 80 # remove this once themes stop using it
  end
end
