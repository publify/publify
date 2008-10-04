module AuthorsHelper
  def title_for_grouping(author)
    "#{pluralize(author.published_articles.size, _('no posts') , _('1 post'), __('%d posts'))} with author #{author.display_name}"
  end
end
