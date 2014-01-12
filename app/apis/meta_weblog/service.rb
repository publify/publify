class MetaWeblog::Service < PublifyWebService
  web_service_api MetaWeblog::Api
  before_invocation :authenticate

  def getPost(postid, username, password)
    article = Article.find(postid)

    article_dto_from(article)
  end

  def getRecentPosts(blogid, username, password, numberOfPosts)
    Article.find(:all, :order => "created_at DESC", :limit => numberOfPosts).collect{ |c| article_dto_from(c) }
  end

  def newPost(blogid, username, password, struct, publish)
    article = Article.new
    article.body        = struct['description'] || ''
    article.title       = struct['title'] || ''
    article.author      = username
    article.published_at = struct['dateCreated'].to_time.getlocal rescue Time.now
    article.published   = publish
    article.user        = @user

    # Movable Type API support
    article.allow_comments = struct['mt_allow_comments']  || this_blog.default_allow_comments
    article.allow_pings    = struct['mt_allow_pings']     || this_blog.default_allow_pings
    article.extended       = struct['mt_text_more']       || ''
    article.text_filter    = TextFilter.find_by_name(struct['mt_convert_breaks'] || this_blog.text_filter)
    article.keywords       = struct['mt_keywords']        || ''

    if !article.save
      raise article.errors.full_messages * ", "
    end

    article.id.to_s
  end

  def deletePost(appkey, postid, username, password, publish)
    Article.destroy(postid)
    true
  end

  def editPost(postid, username, password, struct, publish)
    article = Article.find(postid)
    article.body        = struct['description'] || ''
    article.title       = struct['title'] || ''
    article.published   = publish
    article.author      = username
    article.published_at  = struct['dateCreated'].to_time.getlocal unless struct['dateCreated'].blank?

    # Movable Type API support
    article.allow_comments = struct['mt_allow_comments'] || this_blog.default_allow_comments
    article.allow_pings    = struct['mt_allow_pings']    || this_blog.default_allow_pings
    article.extended       = struct['mt_text_more']      || ''
    article.keywords       = struct['mt_keywords']       || ''
    article.text_filter    = TextFilter.find_by_name(struct['mt_convert_breaks'] || this_blog.text_filter)

    ::Rails.logger.info(struct['mt_tb_ping_urls'])
    article.save
    true
  end

  def newMediaObject(blogid, username, password, data)
    resource = Resource.create(:upload => ResourceUploader::FilelessIO.new(data["bits"], data["name"]), :mime => data['type'], :created_at => Time.now)

    MetaWeblog::Structs::Url.new("url" => this_blog.file_url(resource.upload.url))
  end

  def article_dto_from(article)
    MetaWeblog::Structs::Article.new(
      :description       => article.body,
      :title             => article.title,
      :postid            => article.id.to_s,
      :url               => article.permalink_url,
      :link              => article.permalink_url,
      :permaLink         => article.permalink_url,
      :mt_text_more      => article.extended.to_s,
      :mt_keywords       => article.tags.collect { |p| p.name }.join(', '),
      :mt_allow_comments => article.allow_comments? ? 1 : 0,
      :mt_allow_pings    => article.allow_pings? ? 1 : 0,
      :mt_convert_breaks => (article.text_filter.name.to_s rescue ''),
      :mt_tb_ping_urls   => article.pings.collect { |p| p.url },
      :dateCreated       => (article.published_at.utc rescue '')
      )
  end
end
