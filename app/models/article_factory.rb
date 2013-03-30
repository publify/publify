class ArticleFactory
  def initialize(blog, user)
    @blog, @user = blog, user
  end

  def get_or_build_from(id)
    return Article.find(id) if id.present?
    Article.new.tap do |art|
      art.allow_comments = @blog.default_allow_comments
      art.allow_pings = @blog.default_allow_pings
      art.text_filter = @user.default_text_filter
      art.published = true
    end
  end

end
