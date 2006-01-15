class Plugins::Sidebars::TagController < Sidebars::Plugin
  def self.display_name
    "Tags"
  end

  def self.description
    "Show most popular tags for this blog"
  end

  def self.default_config
    { 'maximum_tags' => 20 }
  end

  def configure
  end

  def content
    @tags = Tag.find_all_with_article_counters(@sb_config['maximum_tags'].to_i).sort_by {|t| t.name}
    total=@tags.inject(0) {|total,tag| total += tag.article_counter }
    average = total.to_f / @tags.size.to_f
    @sizes = @tags.inject({}) {|h,tag| h[tag] = (tag.article_counter.to_f / average); h} # create a percentage
    # apply a lower limit of 50% and an upper limit of 200%
    @sizes.each {|tag,size| @sizes[tag] = [[2.0/3.0, size].max, 2].min * 100}
    @font_multiplier = 80 # remove this once themes stop using it
  end
end
