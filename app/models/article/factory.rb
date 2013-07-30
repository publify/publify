class Article::Factory

  attr_reader :blog, :user

  def initialize(blog, user)
    @blog, @user = blog, user
  end

  def default
    Article.new.tap do |art|
      art.allow_comments = blog.default_allow_comments
      art.allow_pings = blog.default_allow_pings
      art.text_filter = user.default_text_filter
      art.published = true
    end
  end

  def get_or_build_from(id)
    return Article.find(id) if id.present?
    default
  end

end
