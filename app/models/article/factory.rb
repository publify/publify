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

  def match_permalink_format(parts, format)
    specs = format.split('/')
    specs.delete('')
    parts = parts.split('/')
    parts.delete('')

    return if parts.length != specs.length

    article_params = {}

    specs.zip(parts).each do |spec, item|
      if spec =~ /(.*)%(.*)%(.*)/
        before_format = $1
        format_string = $2
        after_format = $3
        result = item.gsub(/^#{before_format}(.*)#{after_format}$/, '\1')
        article_params[format_string.to_sym] = result
      elsif spec != item
        return
      end
    end
    begin
      requested_article(article_params)
    rescue
      #Not really good.
      # TODO :Check in request_article type of DATA made in next step
    end
  end

  def requested_article(params = {})
    params[:title] ||= params[:article_id]
    Article.find_by_permalink(params)
  end

end
