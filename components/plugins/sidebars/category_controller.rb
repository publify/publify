class Plugins::Sidebars::CategoryController < Sidebars::Plugin
  def self.display_name
    "Categories"
  end

  def self.description
    "List of categories for this blog"
  end

  def self.default_config
    {'empty' => false, 'count' => true }
  end

  def content
    @categories = Category.find_all_with_article_counters
  end

  def configure
  end
end
