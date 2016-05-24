class Article::Factory
  attr_reader :blog, :user

  def initialize(blog, user)
    @blog = blog
    @user = user
  end

  def default
    blog.articles.create.tap do |art|
      art.allow_comments = blog.default_allow_comments
      art.allow_pings = blog.default_allow_pings
      art.text_filter = user.default_text_filter
      art.published = true
    end
  end

  def get_or_build_from(id)
    return blog.articles.find(id) if id.present?
    default
  end

  def match_permalink_format(path, format)
    article_params = extract_params(path, format)
    requested_article(article_params) if article_params
  end

  def requested_article(params = {})
    params[:title] ||= params[:article_id]
    Article.find_by_permalink(params)
  end

  def extract_params(path, format)
    specs = format.split('/')
    specs.delete('')
    parts = path.split('/')
    parts.delete('')

    return if parts.length != specs.length

    specs.zip(parts).reduce({}) do |result, (spec, item)|
      if spec =~ /(.*)%(.*)%(.*)/
        before_format = Regexp.last_match[1]
        format_string = Regexp.last_match[2]
        after_format = Regexp.last_match[3]
        item =~ /^#{before_format}(.*)#{after_format}$/
        break unless Regexp.last_match
        value = Regexp.last_match[1]
        result[format_string.to_sym] = value
      elsif spec != item
        break
      end
      result
    end
  end
end
