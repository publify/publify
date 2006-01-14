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
    total=@tags.inject(1) {|total,tag| total += tag.article_counter }
    @font_multiplier = 80
  end
end
