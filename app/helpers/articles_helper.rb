module ArticlesHelper
  def tag_links(article)
    tag_arr = article.tags.map do |tag|
      link_to tag.display_name, tag.permalink_url(nil, true), rel: 'tag'
    end
    safe_join(tag_arr.sort, ', ')
  end
end
