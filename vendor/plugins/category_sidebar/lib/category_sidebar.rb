class CategorySidebar < Sidebar
  display_name "Categories"
  description "List of categories for this blog"

  setting :count, true,  :label => 'Show article count',    :input_type => :checkbox
  setting :empty, false, :label => 'Show empty categories', :input_type => :checkbox

  def categories
    @categories ||= Category.find_all_with_article_counters
  end
end
