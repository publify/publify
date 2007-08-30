module CategoriesHelper
  def ul_tag_for(_)
    %{<ul class="categorylist">}
  end

  def title_for_grouping(category)
    "#{pluralize(category.article_counter, 'post')} with category '#{category.display_name}' TEST"
  end
end
