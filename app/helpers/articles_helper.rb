module ArticlesHelper

  def feed_atom
    url_for(:format => :atom, :only_path => false)
  end

  def feed_rss
    url_for(:format => :rss, :only_path => false)
  end
end
