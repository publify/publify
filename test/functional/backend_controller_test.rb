require File.dirname(__FILE__) + '/../test_helper'
require 'backend_controller'
require 'blogger_service'
require 'digest/sha1'
require 'base64'

# Re-raise errors caught by the controller.
class BackendController; def rescue_action(e) raise e end; end

class BackendControllerTest < Test::Unit::TestCase
  fixtures :articles, :categories, :settings, :trackbacks, :users, :articles_categories

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
    args = [ 'foo', '1', 'tobi', 'whatever', '<title>new post title</title>new post body', 1]

    result = invoke_layered :blogger, :newPost, *args
    assert_not_nil result
    new_post = Article.find(result)
    assert_equal "new post title", new_post.title
    assert_equal "new post body", new_post.body
    assert_equal "textile", new_post.text_filter
    assert_equal @tobi, new_post.user
  end
  
  def test_blogger_new_post_no_title
    args = [ 'foo', '1', 'tobi', 'whatever', 'new post body for post without title but with a lenghty body', 1]

    result = invoke_layered :blogger, :newPost, *args
    assert_not_nil result
    new_post = Article.find(result)
    assert_equal "new post body for post without", new_post.title
    assert_equal "new post body for post without title but with a lenghty body", new_post.body
  end

  def test_blogger_new_post_with_categories
    args = [ 'foo', '1', 'tobi', 'whatever', '<title>new post title</title><category>Software, Hardware</category>new post body', 1]

    result = invoke_layered :blogger, :newPost, *args
    assert_not_nil result
    new_post = Article.find(result)
    assert_equal "new post title", new_post.title
    assert_equal "new post body", new_post.body
    assert_equal [@software, @hardware], new_post.categories.sort_by { |c| c.id }
  end

  def test_blogger_new_post_with_non_existing_categories
    args = [ 'foo', '1', 'tobi', 'whatever', '<title>new post title</title><category>Idontexist, Hardware</category>new post body', 1]

    result = invoke_layered :blogger, :newPost, *args
    assert_not_nil result
    new_post = Article.find(result)
    assert_equal [@hardware], new_post.categories
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
    assert_equal result['title'], 'Article 1!'
  end

  def test_meta_weblog_get_recent_posts
    args = [ 1, 'tobi', 'whatever', 2 ]    
    
    result = invoke_layered :metaWeblog, :getRecentPosts, *args
    assert_equal result.size, 2
    assert_equal result.last['title'], 'Article 2!'
  end

  def test_meta_weblog_delete_post
    args = [ 1, 2, 'tobi', 'whatever', 1 ]
    
    result = invoke_layered :metaWeblog, :deletePost, *args
    assert_raise(ActiveRecord::RecordNotFound) { Article.find(2) }
  end

  def test_meta_weblog_edit_post
    article = Article.find(1)
    article.title = "Modified!"

    args = [ 1, 'tobi', 'whatever', MetaWeblogService.new(@controller).article_dto_from(article), 1 ]

    result = invoke_layered :metaWeblog, :editPost, *args
    assert result
    assert_equal Article.find(1).title, "Modified!"
  end

  def test_meta_weblog_new_post
    article = Article.new
    article.title = "Posted via Test"
    article.body = "body"
    
    args = [ 1, 'tobi', 'whatever', MetaWeblogService.new(@controller).article_dto_from(article), 1 ]

    result = invoke_layered :metaWeblog, :newPost, *args
    assert result
    new_post = Article.find(result)
    assert_equal "Posted via Test", new_post.title
    assert_equal "textile", new_post.text_filter
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
    article.categories << @software

    args = [ 1, 'tobi', 'whatever' ]
    
    result = invoke_layered :mt, :getPostCategories, *args
    assert_equal result.first['categoryName'], article.categories.first['name']
  end

  def test_mt_get_recent_post_titles
    args = [ 1, 'tobi', 'whatever', 2 ]    
    
    result = invoke_layered :mt, :getRecentPostTitles, *args
    assert_equal result.first['title'], Article.find(1).title
  end

  def test_mt_set_post_categories
    args = [ 2, 'tobi', 'whatever',
      [MovableTypeStructs::CategoryPerPost.new('categoryName' => 'personal', 'categoryId' => 3, 'isPrimary' => 1)] ]
    
    result = invoke_layered :mt, :setPostCategories, *args
    assert_equal [@personal], Article.find(2).categories

    args = [ 2, 'tobi', 'whatever',
      [MovableTypeStructs::CategoryPerPost.new('categoryName' => 'Software', 'categoryId' => 1, 'isPrimary' => 1),
       MovableTypeStructs::CategoryPerPost.new('categoryName' => 'Hardware', 'categoryId' => 2, 'isPrimary' => 0) ]]

     result = invoke_layered :mt, :setPostCategories, *args

     assert Article.find(2).categories.include?(@hardware)

  end

  def test_mt_supported_text_filters
    result = invoke_layered :mt, :supportedTextFilters
    assert result.map {|f| f['label']}.include?('Markdown') if  BlueCloth.new rescue false 
    assert result.map {|f| f['label']}.include?('Textile') if  RedCloth.new rescue false 
  end

  def test_mt_get_trackback_pings
    args = [ 1 ]
    
    result = invoke_layered :mt, :getTrackbackPings, *args
    
    assert_equal result.first['pingTitle'], 'Trackback Entry'
  end

  def test_mt_publish_post
    args = [ 4, 'tobi', 'whatever' ]

    assert_equal 0, Article.find(4).published
    
    result = invoke_layered :mt, :publishPost, *args
    
    assert result
    assert_equal 1, Article.find(4).published
  end

  def test_mt_fail_authentication
    args = [ 1, 'tobi', 'using a wrong password', 2 ]
    # This will be a little more useful with the upstream changes in [1093]
    assert_raise(XMLRPC::FaultException) { invoke_layered :mt, :getRecentPostTitles, *args }
  end

end
