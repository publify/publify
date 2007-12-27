require File.dirname(__FILE__) + '/../test_helper'
require 'action_web_service/test_invoke'
require 'backend_controller'
require 'blogger_service'
require 'digest/sha1'
require 'base64'

# Re-raise errors caught by the controller.
class BackendController; def rescue_action(e) raise e end; end

class BackendControllerTest < Test::Unit::TestCase
  include FlexMock::TestCase
  fixtures :contents, :categories, :blogs, :users, :categorizations, :text_filters, :blacklist_patterns, :feedback, :tags, :articles_tags, :notifications, :resources, :triggers

  def setup
    @controller = BackendController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
    @protocol = :xmlrpc
  end

  # BloggerApi Tests
  def test_blogger_delete_post
    args = [ 'foo', 3, 'tobi', 'whatever', 1 ]

    result = invoke_layered :blogger, :deletePost, *args
    assert_raise(ActiveRecord::RecordNotFound) { Article.find(3) }
  end

  def test_blogger_get_users_blogs
    args = [ 'foo', 'tobi', 'whatever' ]

    result = invoke_layered :blogger, :getUsersBlogs, *args
    assert_equal result.first['blogName'], 'test blog'
  end

  def test_blogger_get_user_info
    args = [ 'foo', 'tobi', 'whatever' ]

    result = invoke_layered :blogger, :getUserInfo, *args
    assert_equal 'tobi', result['userid']
  end

  def test_blogger_new_post
    args = [ 'foo', '1', 'tobi', 'whatever', '<title>new post title</title>new post *body*', 1]

    result = invoke_layered :blogger, :newPost, *args
    assert_not_nil result
    new_post = Article.find(result)
    assert_equal "new post title", new_post.title
    assert_equal "new post *body*", new_post.body
    assert_equal "<p>new post <strong>body</strong></p>", new_post.html(:body)
    assert_equal "textile", new_post.text_filter.name
    assert_equal users(:tobi), new_post.user
    assert_equal this_blog.id, new_post.blog_id
    assert new_post.published?
    assert new_post[:published_at]
  end

  def test_blogger_new_post_no_title
    args = [ 'foo', '1', 'tobi', 'whatever', 'new post body for post without title but with a lenghty body', 1]

    result = invoke_layered :blogger, :newPost, *args
    assert_not_nil result
    new_post = Article.find(result)
    assert_equal "new post body for post without", new_post.title
    assert_equal "new post body for post without title but with a lenghty body", new_post.body
    assert_equal "<p>new post body for post without title but with a lenghty body</p>", new_post.html(:body)
  end

  def test_blogger_new_post_with_categories
    args = [ 'foo', '1', 'tobi', 'whatever', '<title>new post title</title><category>Software, Hardware</category>new post body', 1]

    result = invoke_layered :blogger, :newPost, *args
    assert_not_nil result
    new_post = Article.find(result)
    assert_equal "new post title", new_post.title
    assert_equal "new post body", new_post.body
    assert_equal [categories(:software), categories(:hardware)], new_post.categories.sort_by { |c| c.id }
    assert_equal this_blog.id, new_post.blog_id
    assert new_post.published?
  end

  def test_blogger_new_post_with_non_existing_categories
    args = [ 'foo', '1', 'tobi', 'whatever', '<title>new post title</title><category>Idontexist, Hardware</category>new post body', 1]

    result = invoke_layered :blogger, :newPost, *args
    assert_not_nil result
    new_post = Article.find(result)
    assert_equal [categories(:hardware)], new_post.categories
    assert_equal this_blog.id, new_post.blog_id
  end

  def test_blogger_fail_authentication
    args = [ 'foo', 'tobi', 'using a wrong password' ]
    # This will be a little more useful with the upstream changes in [1093]
    assert_raise(XMLRPC::FaultException) { invoke_layered :blogger, :getUsersBlogs, *args }
  end

  # Meta Weblog Tests
  def test_meta_weblog_get_categories
    args = [ 1, 'tobi', 'whatever' ]

    result = invoke_layered :metaWeblog, :getCategories, *args
    assert_equal 'Software', result.first
  end

  def test_meta_weblog_get_post
    args = [ 1, 'tobi', 'whatever' ]

    result = invoke_layered :metaWeblog, :getPost, *args
    assert_equal result['title'], Article.find(1).title
  end

  def test_meta_weblog_get_recent_posts
    args = [ 1, 'tobi', 'whatever', 2 ]

    result = invoke_layered :metaWeblog, :getRecentPosts, *args
    assert_equal result.size, 2
    assert_equal result.last['title'], Article.find(:first, :offset => 1, :order => 'created_at desc').title
  end

  def test_meta_weblog_delete_post
    args = [ 1, 2, 'tobi', 'whatever', 1 ]

    result = invoke_layered :metaWeblog, :deletePost, *args
    assert_raise(ActiveRecord::RecordNotFound) { Article.find(2) }
  end

  def test_meta_weblog_edit_post
    article = Article.find(1)
    article.title = "Modified!"
    article.body = "this is a *test*"
    article.text_filter = TextFilter.find_by_name("textile")
    article.published_at = Time.now.utc.midnight

    args = [ 1, 'tobi', 'whatever', MetaWeblogService.new(@controller).article_dto_from(article), 1 ]

    result = invoke_layered :metaWeblog, :editPost, *args
    assert result

    new_article = Article.find(1)

    assert_equal article.title, new_article.title
    assert_equal article.body, new_article.body
    assert_equal "<p>this is a <strong>test</strong></p>", new_article.html(:body)
    assert_equal Time.now.midnight.utc, new_article.published_at.utc
    assert_equal this_blog.id, new_article.blog_id
  end

  # TODO: reduce amount of mocking needed?
  def test_meta_weblog_new_post_fails
    stub_args = [:id_stub, :username_stub, :password_stub, {}, :publish_stub]
    @controller = MetaWeblogService.new(:controller_stub)
    @article = Article.new
    flexmock(@article).should_receive(:save).returns(false).once
    @this_blog = flexmock(:articles => flexmock(:build => @article))
    @this_blog.should_ignore_missing
    flexmock(@controller, :this_blog => @this_blog)
    assert_raises(RuntimeError) { @controller.newPost(*stub_args) }
  end
  
  def test_meta_weblog_new_post
    article = Article.new
    article.title = "Posted via Test"
    article.body = "body"
    article.extended = "extend me"
    article.text_filter = TextFilter.find_by_name("textile")
    article.published_at = Time.now.utc.midnight

    args = [ 1, 'tobi', 'whatever', MetaWeblogService.new(@controller).article_dto_from(article), 1 ]

    result = invoke_layered :metaWeblog, :newPost, *args
    assert result
    new_post = Article.find(result)

    assert_equal "Posted via Test", new_post.title
    assert_equal "textile", new_post.text_filter.name
    assert_equal article.body, new_post.body
    assert_equal "<p>body</p>", new_post.html(:body)
    assert_equal article.extended, new_post.extended
    assert_equal "<p>extend me</p>", new_post.html(:extended)
    assert_equal Time.now.midnight.utc, new_post.published_at.utc
    assert_equal this_blog.id, new_post.blog_id
  end

  def test_meta_weblog_new_media_object
    media_object = MetaWeblogStructs::MediaObject.new(
      "name" => Digest::SHA1.hexdigest("upload-test--#{Time.now}--") + ".jpg",
      "type" => "image/jpeg",
      "bits" => Base64.encode64(File.open(File.expand_path(RAILS_ROOT) + "/public/images/header.jpg", "rb") { |f| f.read })
    )

    args = [ 1, 'tobi', 'whatever', media_object ]

    result = invoke_layered :metaWeblog, :newMediaObject, *args
    assert result['url'] =~ /#{media_object['name']}/
    assert File.unlink(File.expand_path(RAILS_ROOT) + "/public/files/#{media_object['name']}")
  end

  def test_meta_weblog_fail_authentication
    args = [ 1, 'tobi', 'using a wrong password', 2 ]
    # This will be a little more useful with the upstream changes in [1093]
    assert_raise(XMLRPC::FaultException) { invoke_layered :metaWeblog, :getRecentPosts, *args }
  end
  
  # Movable Type Tests

  def test_mt_get_category_list
    args = [ 1, 'tobi', 'whatever' ]

    result = invoke_layered :mt, :getCategoryList, *args
    assert result.map { |c| c['categoryName'] }.include?('Software')
  end

  def test_mt_get_post_categories
    article = Article.find(1)
    article.categories << categories(:software)

    args = [ 1, 'tobi', 'whatever' ]

    result = invoke_layered :mt, :getPostCategories, *args
    assert_equal Set.new(result.collect {|v| v['categoryName']}), Set.new(article.categories.collect(&:name))
  end

  def test_mt_get_recent_post_titles
    args = [ 1, 'tobi', 'whatever', 2 ]

    result = invoke_layered :mt, :getRecentPostTitles, *args
    assert_equal result.first['title'], Article.find(2).title
  end

  def test_mt_set_post_categories
    args = [ 2, 'tobi', 'whatever',
      [MovableTypeStructs::CategoryPerPost.new('categoryName' => 'personal', 'categoryId' => 3, 'isPrimary' => 1)] ]

    result = invoke_layered :mt, :setPostCategories, *args
    assert_equal [categories(:personal)], Article.find(2).categories

    args = [ 2, 'tobi', 'whatever',
      [MovableTypeStructs::CategoryPerPost.new('categoryName' => 'Software', 'categoryId' => 1, 'isPrimary' => 1),
       MovableTypeStructs::CategoryPerPost.new('categoryName' => 'Hardware', 'categoryId' => 2, 'isPrimary' => 0) ]]

     result = invoke_layered :mt, :setPostCategories, *args

     assert Article.find(2).categories.include?(categories(:hardware))

  end

  def test_mt_supported_text_filters
    result = invoke_layered :mt, :supportedTextFilters
    assert result.map {|f| f['label']}.include?('Markdown')
    assert result.map {|f| f['label']}.include?('Textile')
  end

  def test_mt_supported_methods
    result = invoke_layered :mt, :supportedMethods
    assert_equal 8, result.size
    assert result.include?("publishPost")
  end

  def test_mt_get_trackback_pings
    args = [ 1 ]

    result = invoke_layered :mt, :getTrackbackPings, *args

    assert_equal result.first['pingTitle'], 'Trackback Entry'
  end

  def test_mt_publish_post
    args = [ 4, 'tobi', 'whatever' ]

    assert (not Article.find(4).published?)

    result = invoke_layered :mt, :publishPost, *args

    assert result
    assert Article.find(4).published?
    assert Article.find(4)[:published_at]
  end

  def test_mt_fail_authentication
    args = [ 1, 'tobi', 'using a wrong password', 2 ]
    # This will be a little more useful with the upstream changes in [1093]
    assert_raise(XMLRPC::FaultException) { invoke_layered :mt, :getRecentPostTitles, *args }
  end

end
