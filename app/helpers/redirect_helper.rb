module RedirectHelper
  def template_path
    'articles'
  end

  def feed_rss
    @article.feed_url(:rss20)
  end

  def feed_atom
    @article.feed_url(:atom)
  end
end
