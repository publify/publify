module AuthorsHelper
  def title_for_grouping(author)
    "#{pluralize(author.published_articles.size, 'post')} with author #{author.display_name}"
  end
end
