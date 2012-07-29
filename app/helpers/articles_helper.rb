module ArticlesHelper
  def article_links(article, separator="&nbsp;<strong>|</strong>&nbsp;")
    code = []
    code << category_links(article)   unless article.categories.empty?
    code << tag_links(article)        unless article.tags.empty?
    code << comments_link(article)    if article.allow_comments?
    code << trackbacks_link(article)  if article.allow_pings?
    code.join(separator)
  end
end
