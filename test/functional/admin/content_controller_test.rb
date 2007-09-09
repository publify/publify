require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/content_controller'

require 'http_mock'

# Re-raise errors caught by the controller.
class Admin::ContentController; def rescue_action(e) raise e end; end

class Admin::ContentControllerTest < Test::Unit::TestCase
  fixtures :contents, :feedback, :users, :categories, :resources, :text_filters,
           :blogs, :categorizations

  def setup
    @controller = Admin::ContentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session = { :user_id => users(:tobi).id }
  end

  def test_index
    get :index
    assert_template 'list'
  end

  def test_list
    get :list
    assert_template 'list'
    assert_template_has 'articles'
  end

  def test_show
    get :show, 'id' => 1
    assert_template 'show'
    assert_template_has 'article'
    assert_valid assigns(:article)
    assert_not_nil assigns(:article)
    assert_not_nil assigns(:categories)
    assert_not_nil assigns(:resources)
  end

  def test_new
    get :new
    assert_template 'new'
    assert_template_has 'article'
  end

  def test_create_no_comments
    post(:new, 'article' => { :title => "posted via tests!", :body => "You can't comment",
                              :keywords => "tagged",
                              :allow_comments => '0', :allow_pings => '1' },
               'categories' => [1])
    assert !assigns(:article).allow_comments?
    assert  assigns(:article).allow_pings?
    assert  assigns(:article).published?
  end

  def test_create_with_no_pings
    post(:new, 'article' => { :title => "posted via tests!", :body => "You can't ping!",
                              :keywords => "tagged",
                              :allow_comments => '1', :allow_pings => '0' },
               'categories' => [1])
    assert  assigns(:article).allow_comments?
    assert !assigns(:article).allow_pings?
    assert  assigns(:article).published?
  end

  def test_create
    num_articles = this_blog.published_articles.size
    emails = ActionMailer::Base.deliveries
    emails.clear
    tags = ['foo', 'bar', 'baz bliz', 'gorp gack gar']
    post :new, 'article' => { :title => "posted via tests!", :body => "Foo", :keywords => "foo bar 'baz bliz' \"gorp gack gar\""}, 'categories' => [1]
    assert_response :redirect, :action => 'show'

    assert_equal num_articles + 1, this_blog.published_articles.size

    new_article = Article.find(:first, :order => "id DESC")
    assert_equal users(:tobi), new_article.user
    assert_equal 1, new_article.categories.size
    assert_equal [1], new_article.categories.collect {|c| c.id}
    assert_equal 4, new_article.tags.size

    assert_equal(1, emails.size)
    assert_equal('randomuser@example.com', emails.first.to[0])
  end

  def test_create_future_article
    num_articles = this_blog.published_articles.size
    post(:new,
         :article => { :title => "News from the future!",
                       :body => "The future's cool!",
                       :published_at => Time.now + 1.hour })
    assert_response :redirect, :action => 'show'
    assert ! assigns(:article).published?
    assert_equal num_articles, this_blog.published_articles.size
    assert_equal 1, Trigger.count
  end

  def test_request_fires_triggers
    art = this_blog.articles.create!(:title => 'future article',
                                     :body => 'content',
                                     :published_at => Time.now + 2.seconds,
                                     :published => true)
    assert !art.published?
    sleep 3
    get(:show, :id => art.id)
    assert assigns(:article).published?
  end

  def test_create_filtered
    body = "body via *textile*"
    extended="*foo*"
    post :new, 'article' => { :title => "another test", :body => body, :extended => extended}
    assert_response :redirect, :action => 'show'

    new_article = Article.find(:first, :order => "created_at DESC")
    assert_equal body, new_article.body
    assert_equal extended, new_article.extended
    assert_equal "textile", new_article.text_filter.name
    assert_equal "<p>body via <strong>textile</strong></p>", new_article.html(:body)
    assert_equal "<p><strong>foo</strong></p>", new_article.html(:extended)
  end

  def test_edit
    get :edit, 'id' => 1
    assert_equal assigns(:selected), Article.find(1).categories.collect {|c| c.id}
    assert_template 'edit'
    assert_template_has 'article'
    assert_valid assigns(:article)
  end

  def test_update
    emails = ActionMailer::Base.deliveries
    emails.clear

    body = "another *textile* test"
    post :edit, 'id' => 1, 'article' => {:body => body, :text_filter => 'textile'}
    assert_response :redirect, :action => 'show', :id => 1

    article = Article.find(1)
    assert_equal "textile", article.text_filter.name
    assert_equal body, article.body

    assert_equal 0, emails.size
  end

  def test_destroy
    assert_not_nil Article.find(1)

    get :destroy, 'id' => 1
    assert_response :success

    post :destroy, 'id' => 1
    assert_response :redirect, :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      article = Article.find(1)
    }
  end

  def test_category_add
    get :category_add, :id => 1, :category_id => 1

    assert_template '_show_categories'
    assert_valid assigns(:article)
    assert_valid assigns(:category)
    assert Article.find(1).categories.include?(Category.find(1))
    assert_not_nil assigns(:article)
    assert_not_nil assigns(:category)
    assert_not_nil assigns(:categories)
  end

  def test_category_remove
    get :category_remove, :id => 1, :category_id => 1

    assert_template '_show_categories'
    assert_valid assigns(:article)
    assert_valid assigns(:category)
    assert !Article.find(1).categories.include?(Category.find(1))
    assert_not_nil assigns(:article)
    assert_not_nil assigns(:category)
    assert_not_nil assigns(:categories)
  end

  def test_resource_add
    get :resource_add, :id => 1, :resource_id => 1

    assert_template '_show_resources'
    assert_valid assigns(:article)
    assert_valid assigns(:resource)
    assert Article.find(1).resources.include?(Resource.find(1))
    assert_not_nil assigns(:article)
    assert_not_nil assigns(:resource)
    assert_not_nil assigns(:resources)
  end

  def test_resource_remove
    get :resource_remove, :id => 1, :resource_id => 1

    assert_template '_show_resources'
    assert_valid assigns(:article)
    assert_valid assigns(:resource)
    assert !Article.find(1).resources.include?(Resource.find(1))
    assert_not_nil assigns(:article)
    assert_not_nil assigns(:resource)
    assert_not_nil assigns(:resources)
  end

  def test_attachment_box_add
    get :attachment_box_add, :id => 2
    assert_template '_attachment'
    #assert_tag :tag => 'script'
  end

  def test_resource_container
    get :show, :id => contents(:article1).id # article without attachments
    Resource.find(:all).each do |resource|
      assert_tag( :tag => 'a',
                  :attributes =>{
                    :onclick =>
                      /^new Ajax.Updater\('resources/
                  },
                  :content => /[-+] #{resource.filename}/)
    end
  end
end
