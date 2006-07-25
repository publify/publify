require File.dirname(__FILE__) + '/../test_helper'
require 'articles_controller'
require 'dns_mock'
require 'http_mock'

require 'content'

#
# Re-raise errors caught by the controller.
class ArticlesController; def rescue_action(e) raise e end; end

class Content
  def self.find_last_posted
    self.find(:first, :conditions => ['created_at < ?', Time.now],
              :order => 'created_at desc')
  end
end

class ArticlesControllerTest < Test::Unit::TestCase
  fixtures :contents, :categories, :blogs, :users, :articles_categories, :text_filters, :articles_tags, :tags
  include ArticlesHelper

  def setup
    @controller = ArticlesController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new

    Article.create!(:title => "News from the future!",
                    :body => "The future is cool!",
                    :keywords => "future",
                    :created_at => Time.now + 12.minutes)

  end

  # Category subpages
  def test_category
    get :category, :id => "software"

    assert_response :success
    assert_rendered_file "index"
    assert_tag :tag => 'title', :content => 'test blog - category software'

    # Check it works when permalink != name. Ticket #736
    get :category, :id => "weird-permalink"

    assert_response :success
    assert_rendered_file "index"
  end

  def test_empty_category
    get :category, :id => "life-on-mars"
    assert_response :success
    assert_rendered_file "error"
  end

  def test_nonexistent_category
    get :category, :id => 'nonexistent-category'
    assert_response :success
    assert_rendered_file "error"
  end

  def test_tag
    get :tag, :id => "foo"

    assert_response :success
    assert_rendered_file "index"

    assert_tag :tag => 'title', :content => 'test blog - tag foo'
    assert_tag :tag => 'h2', :content => 'Article 2!'
    assert_tag :tag => 'h2', :content => 'Article 1!'
  end

  def test_nonexistent_tag
    get :tag, :id => "nonexistent"
    assert_response :success
    assert_rendered_file "error"
  end

  def test_tag_routes
    opts = {:controller => "articles", :action => "tag", :id => "foo", :page => "2"}
    assert_routing("articles/tag/foo/page/2", opts)
  end

  def test_simple_tag_pagination
    this_blog.limit_article_display = 1
    get :tag, :id => "foo"
    assert_equal 1, assigns(:articles).size
    assert_tag(:tag => 'p',
               :attributes =>{
                  :id => 'pagination'},
               :content => 'Older posts: 1',
               :descendant => {:tag => 'a',
                               :attributes =>{
                                  :href => "/articles/tag/foo/page/2"},
                               :content => "2"})
  end

  # Main index
  def test_index
    get :index
    assert_response :success
    assert_rendered_file "index"
  end

  # Archives page
  def test_archives
    get :archives
    assert_response :success
    assert_rendered_file "archives"
  end

  # Permalinks
  def test_permalink
    get :permalink, :year => 2004, :month => 06, :day => 01, :title => "article-3"
    assert_response :success
    assert_template "read"
    assert_not_nil assigns(:article)
    assert_equal contents(:article3), assigns(:article)
  end

  # Posts for given day
  def test_find_by_date
    get :find_by_date, :year => 2004, :month => 06, :day => 01
    assert_response :success
    assert_rendered_file "index"
  end

  def test_comment_posting
    emails = ActionMailer::Base.deliveries
    emails.clear

    assert_equal 0, emails.size

    Article.find(1).notify_users << users(:tobi)

    post :comment, { :id => 1, :comment => {'body' => 'This is *textile*', 'author' => 'bob' }}

    assert_response :success
    assert_tag :tag => 'strong', :content => 'textile'

    comment = Article.find(1).comments.last
    assert comment

    assert_not_nil cookies["author"]

    assert_equal "<p>This is <strong>textile</strong></p>", comment.html(@controller).to_s

    assert_equal User.find(:all,
                           :conditions => ['(notify_via_email = ?) and (notify_on_comments = ?)', true, true],
                           :order => 'email').collect { |each| each.email },
                 emails.collect { |each| each.to[0] }.sort
  end

  def test_comment_spam_markdown_smarty
    this_blog.comment_text_filter = "markdown smartypants"
    test_comment_spam1
  end

  def comment_template_test(expected_html, source_text,
                            art_id=1, author='bob', email='foo', args={})
    post :comment, {
      :id => art_id,
      :comment => {
        'body' => source_text,
        'author' => author,
        'email' => email }.merge(args) }

    assert_response :success
    comment = Article.find(art_id).comments.last
    assert comment

    assert_match expected_html, comment.html(@controller).to_s
    $do_breakpoints
  end

  def test_comment_spam1
    comment_template_test "<p>Link to <a href=\"http://spammer.example.com\" rel=\"nofollow\">spammy goodness</a></p>", 'Link to <a href="http://spammer.example.com">spammy goodness</a>'
  end

  def test_comment_spam2
    comment_template_test %r{<p>Link to <a href=["']http://spammer.example.com['"] rel=["']nofollow['"]>spammy goodness</a></p>}, 'Link to "spammy goodness":http://spammer.example.com'
  end

  def test_comment_xss1
    this_blog.comment_text_filter = "none"
    comment_template_test %{Have you ever alert("foo"); been hacked?},
    %{Have you ever <script lang="javascript">alert("foo");</script> been hacked?}
  end

  def test_comment_xss2
    this_blog.comment_text_filter = "none"
    comment_template_test "Have you ever <a href=\"#\" rel=\"nofollow\">been hacked?</a>", 'Have you ever <a href="#" onclick="javascript">been hacked?</a>'
  end

  def test_comment_autolink
    comment_template_test "<p>What&#8217;s up with <a href=\"http://slashdot.org\" rel=\"nofollow\">http://slashdot.org</a> these days?</p>", "What's up with http://slashdot.org these days?"
  end #"

  ### TODO -- there's a bug in Rails with auto_links
#   def test_comment_autolink2
#     comment_template_test "<p>My web page is <a href='http://somewhere.com/~me/index.html' rel=\"nofollow\">http://somewhere.com/~me/index.html</a></p>", "My web page is http://somewhere.com/~me/index.html"
#   end

  def test_comment_nuking
    num_comments = Comment.count
    post :nuke_comment, { :id => 5 }, {}
    assert_response 403

    get :nuke_comment, { :id => 5 }, { :user => users(:bob)}
    assert_response 403

    post :nuke_comment, { :id => 5 }, { :user => users(:bob)}
    assert_response :success
    assert_equal num_comments -1, Comment.count
  end

  def test_comment_user_blank
    post :comment, { :id => 2, :comment => {'body' => 'foo', 'author' => 'bob' }}
    assert_response :success

    comment = Article.find(2).comments.last
    assert comment
    assert comment.published?
    assert_nil comment.user_id

    get :read, {:id => 2}
    assert_response :success
    assert_no_tag :tag => "li",
       :attributes => { :class => "author_comment"}

  end

  def test_comment_user_set
    @request.session = { :user => users(:tobi) }
    post :comment, { :id => 2, :comment => {'body' => 'foo', 'author' => 'bob' }}
    assert_response :success

    comment = Article.find(2).comments.last
    assert comment
    assert_equal users(:tobi), comment.user

    get :read, {:id => 2}
    assert_response :success
    assert_tag :tag => "li",
       :attributes => { :class => "author_comment"}
  end

  def test_trackback
    num_trackbacks = Article.find(2).trackbacks.count
    post :trackback, { :id => 2, :url => "http://www.google.com", :title => "My Trackback", :excerpt => "This is a test" }
    assert_response :success
    assert_not_xpath(%{/response/error[text()="1"]}, "Error: " + get_xpath("/response/message/text()").first.to_s)

    assert_equal num_trackbacks+1, Article.find(2).trackbacks.count
  end

  def test_trackback_nuking
    num_comments = Trackback.count

    post :nuke_trackback, { :id => 7 }, {}
    assert_response 403

    get :nuke_trackback, { :id => 7 }, { :user => users(:bob)}
    assert_response 403

    post :nuke_trackback, { :id => 7 }, { :user => users(:bob)}
    assert_response :success
    assert_equal num_comments -1, Trackback.count
  end

  def test_no_settings
    this_blog.update_attribute(:settings, { })

    get :index

    assert_redirect
    assert_redirected_to :controller => "admin/general", :action => "redirect"

  end

  def test_no_users_exist
    this_blog.update_attribute(:settings, { })

    User.destroy_all
    assert User.count.zero?

    get :index
    assert_redirect
    assert_redirected_to :controller => "accounts", :action => "signup"

  end

  def test_pages_static
    get :view_page, :name => 'page_one'
    assert_response :success
    assert_rendered_file "view_page"

    get :view_page, :name => 'page one'
    assert_response 404
  end

  def test_read_non_published
    get :read, :id => 4
    assert_response :success
    assert_template "error"
  end

  def test_tags_non_published
    get :tag, :id => 'bar'
    assert_response :success
    assert_equal 1, assigns(:articles).size
    assert ! assigns(:articles).include?(@article4), "Unpublished article displayed"
  end

  def test_gravatar
    assert ! this_blog.use_gravatar
    get :read, :id => 1
    assert_response :success
    assert_template "read"
    assert_no_tag :tag => "img",
      :attributes => { :class => "gravatar" }

    # Switch gravatar integration to on
    this_blog.use_gravatar = true
    assert this_blog.use_gravatar
    get :read, :id => 1
    assert_response :success
    assert_template "read"
    assert_tag :tag => "img",
      :attributes => {
        :class => "gravatar",
        :src => "http://www.gravatar.com/avatar.php?gravatar_id=740618d2fe0450ec244d8b86ac1fe3f8&amp;size=60"
      }
  end

  def test_comment_preview
    get :comment_preview
    assert_response :success
    assert_template nil

    get :comment_preview, :comment => { :author => "bob", :body => "comment preview" }
    assert_response :success
    assert_template "comment_preview"

    assert_tag :tag => "cite",
      :children => { :count => 1,
        :only => { :tag => "strong",
          :content => "bob" } }

    assert_tag :tag => "p",
      :content => "comment preview"
  end

  def test_read_article_with_comments_and_trackbacks
    get :read, :id => contents(:article1).id
    assert_response :success
    assert_template "read"
    
    assert_equal contents(:article1).comments.to_a.select{|c| c.published?}, contents(:article1).published_comments

    assert_tag :tag => "ol",
      :attributes => { :id => "commentList"},
      :children => { :count => contents(:article1).comments.to_a.select{|c| c.published?}.size,
        :only => { :tag => "li" } }

    assert_tag :tag => "li",
       :attributes => { :class => "author_comment"}

    assert_tag :tag => "ol",
      :attributes => { :id => "trackbackList" },
      :children => { :count => contents(:article1).trackbacks.size,
        :only => { :tag => "li" } }
  end

  def test_read_article_no_comments_no_trackbacks
    get :read, :id => contents(:article3).id
    assert_response :success
    assert_template "read"

    assert_tag :tag => "ol",
      :attributes => { :id => "commentList"},
      :children => { :count => 1,
        :only => { :tag => "li",
          :attributes => { :id => "dummy_comment", :style => "display: none" } } }

    assert_no_tag :tag => "ol",
      :attributes => { :id => "trackbackList" }
  end

  def test_autodiscovery_default

    get :index
    assert_response :success
    assert_tag :tag => 'link', :attributes =>
      { :rel => 'alternate', :type => 'application/rss+xml', :title => 'RSS',
        :href => 'http://test.host/xml/rss20/feed.xml'}
    assert_tag :tag => 'link', :attributes =>
      { :rel => 'alternate', :type => 'application/atom+xml', :title => 'Atom',
        :href => 'http://test.host/xml/atom/feed.xml'}
  end


  def test_autodiscovery_article
    get :read, :id => 1
    assert_response :success
    assert_tag :tag => 'link', :attributes =>
      { :rel => 'alternate', :type => 'application/rss+xml', :title => 'RSS',
        :href => 'http://test.host/xml/rss20/article/1/feed.xml'}
    assert_tag :tag => 'link', :attributes =>
      { :rel => 'alternate', :type => 'application/atom+xml', :title => 'Atom',
        :href => 'http://test.host/xml/atom/article/1/feed.xml'}
  end

  def test_autodiscovery_category
    get :category, :id => 'hardware'
    assert_response :success
    assert_tag :tag => 'link', :attributes =>
      { :rel => 'alternate', :type => 'application/rss+xml', :title => 'RSS',
        :href => 'http://test.host/xml/rss20/category/hardware/feed.xml'}
    assert_tag :tag => 'link', :attributes =>
      { :rel => 'alternate', :type => 'application/atom+xml', :title => 'Atom',
        :href => 'http://test.host/xml/atom/category/hardware/feed.xml'}
  end

  def test_autodiscovery_tag
    get :tag, :id => 'hardware'
    assert_response :success
    assert_tag :tag => 'link', :attributes =>
      { :rel => 'alternate', :type => 'application/rss+xml', :title => 'RSS',
        :href => 'http://test.host/xml/rss20/tag/hardware/feed.xml'}
    assert_tag :tag => 'link', :attributes =>
      { :rel => 'alternate', :type => 'application/atom+xml', :title => 'Atom',
        :href => 'http://test.host/xml/atom/tag/hardware/feed.xml'}
  end

  def test_disabled_ajax_comments
    this_blog.sp_allow_non_ajax_comments = false
    assert_equal false, this_blog.sp_allow_non_ajax_comments

    post :comment, :id => 1, :comment => {'body' => 'This is posted without ajax', 'author' => 'bob' }
    assert_response 500
    assert_equal "non-ajax commenting is disabled", @response.body

    @request.env['HTTP_X_REQUESTED_WITH'] = "XMLHttpRequest"
    post :comment, :id => 1, :comment => {'body' => 'This is posted *with* ajax', 'author' => 'bob' }
    assert_response :success
    ajax_comment = Article.find(1).comments.last
    assert_equal "This is posted *with* ajax", ajax_comment.body
  end

  def test_tag_max_article_count_is_first
    tags = Tag.find_all_with_article_counters
    assert tags.size > 1
    max = tags[0].article_counter
    tags.each do |tag|
      assert tag.article_counter <= max
    end
  end

  def test_calc_distributed_class_basic
    assert_equal "prefix5", calc_distributed_class(0, 0, "prefix", 5, 15)
    (0..10).each do |article|
      assert_equal "prefix#{article}", calc_distributed_class(article, 10, "prefix", 0, 10)
    end
    (0..20).each do |article|
      assert_equal "prefix#{(article/2).to_i}", calc_distributed_class(article, 20, "prefix", 0, 10)
    end
    (0..5).each do |article|
      assert_equal "prefix#{(article*2).to_i}", calc_distributed_class(article, 5, "prefix", 0, 10)
    end
  end

  def test_calc_distributed_class_offset
    (0..10).each do |article|
      assert_equal "prefix#{article+6}", calc_distributed_class(article, 10, "prefix", 6, 16)
    end
  end

  def test_hide_future_article
    @article = Article.find_last_posted

    Article.create!(:title      => "News from the future!",
                    :body       => "The future is cool!",
                    :keywords   => "future",
                    :published  => true,
                    :published_at => Time.now + 12.minutes)
    get :index
    assert_equal @article, assigns(:articles).first
    assert @response.lifetime.to_i <= 12.minutes
  end

  def test_search
    get :search, :q => "search target"
    assert_equal 1, assigns(:articles).size
  end

  def test_author
    get :author, :id => 'tobi'

    assert_success
    assert_rendered_file 'index'
    assert assigns(:articles)
    assert_equal users(:tobi).articles.published, assigns(:articles)
    # This is until we write a proper author feed
    assert_equal('http://test.host/xml/rss20/feed.xml',
                 assigns(:auto_discovery_url_rss))
  end

  def test_nonexistent_author
    get :author, :id => 'nonexistent-chap'

    assert_success
    assert_rendered_file 'error'
    assert assigns(:message)
    assert_equal "Can't find posts with author 'nonexistent-chap'", assigns(:message)
  end

  def test_author_list
    get :author

    assert_success
    assert_rendered_file 'groupings'

    assert_tag(:tag => 'ul',
               :descendant => {\
                 :tag => 'a',
                 :attributes => { :href => '/articles/author/tobi' },
               })
  end
end
