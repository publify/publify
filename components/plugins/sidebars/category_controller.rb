class Plugins::Sidebars::CategoryController < Sidebars::ComponentPlugin
  model :category

  display_name "Categories"
  description "List of categories for this blog"

  setting :count, true,  :label => 'Show article count',    :input_type => :checkbox
  setting :empty, false, :label => 'Show empty categories', :input_type => :checkbox

  def content
    @categories = Category.find_all_with_article_counters
  end
end
