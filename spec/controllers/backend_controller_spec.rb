require 'spec_helper'
require 'action_web_service/test_invoke'

describe BackendController do
  include ActionWebService::TestInvoke::InstanceMethods

  before do
    User.stub(:salt).and_return('change-me')

    #TODO Need to reduce user, but allow to remove user fixture...
    FactoryGirl.create(:user,
            :login => 'henri',
            :password => 'whatever',
            :name => 'Henri',
            :email => 'henri@example.com',
            :settings => {:notify_watch_my_articles => false},
            :text_filter => FactoryGirl.create(:markdown),
            :profile => FactoryGirl.create(:profile_admin, :label => Profile::ADMIN),
            :notify_via_email => false,
            :notify_on_new_articles => false,
            :notify_on_comments => false,
            :state => 'active')

    FactoryGirl.create(:blog)
    @protocol = :xmlrpc
  end

  describe "when called through Blogger API" do
    it "test_blogger_delete_post" do
      article = FactoryGirl.create(:article)
      args = [ 'foo', article.id, 'henri', 'whatever', 1 ]

      result = invoke_layered :blogger, :deletePost, *args
      assert_raise(ActiveRecord::RecordNotFound) { Article.find(article.id) }
    end

    it "test_blogger_get_users_blogs" do
      args = [ 'foo', 'henri', 'whatever' ]

      result = invoke_layered :blogger, :getUsersBlogs, *args
      assert_equal 'test blog', result.first['blogName']
    end

    it "test_blogger_get_user_info" do
      args = [ 'foo', 'henri', 'whatever' ]

      result = invoke_layered :blogger, :getUserInfo, *args
      assert_equal 'henri', result['userid']
    end

    it "test_blogger_new_post" do
      alice = FactoryGirl.create(:user, :login => 'alice', :password => 'whatever')
      args = [ 'foo', '1', 'alice', 'whatever', '<title>new post title</title>new post *body*', 1]

      result = invoke_layered :blogger, :newPost, *args
      assert_not_nil result
      new_post = Article.find(result)
      assert_equal "new post title", new_post.title
      assert_equal "new post *body*", new_post.body
      assert_equal "<p>new post <strong>body</strong></p>", new_post.html(:body)
      assert_equal "textile", new_post.text_filter.name
      assert_equal alice, new_post.user
      assert new_post.published?
      assert new_post[:published_at]
    end

    it "test_blogger_new_post_no_title" do
      args = [ 'foo', '1', 'henri', 'whatever', 'new post body for post without title but with a lenghty body', 1]

      result = invoke_layered :blogger, :newPost, *args
      assert_not_nil result
      new_post = Article.find(result)
      assert_equal "new post body for post without", new_post.title
      assert_equal "new post body for post without title but with a lenghty body", new_post.body
      assert_equal "<p>new post body for post without title but with a lenghty body</p>", new_post.html(:body)
    end

    it "test_blogger_fail_authentication" do
      args = [ 'foo', 'henri', 'using a wrong password' ]
      # This will be a little more useful with the upstream changes in [1093]
      assert_raise(XMLRPC::FaultException) { invoke_layered :blogger, :getUsersBlogs, *args }
    end
  end

  describe "when called through the MetaWeblog API" do

    it "test_meta_weblog_get_post" do
      article = FactoryGirl.create(:article)
      args = [ article.id, 'henri', 'whatever' ]

      result = invoke_layered :metaWeblog, :getPost, *args
      assert_equal result['title'], article.title
    end

    it "test_meta_weblog_get_recent_posts" do
      article = FactoryGirl.create(:article, :created_at => Time.now - 1.day,
        :allow_pings => true, :published => true)
      article_before = FactoryGirl.create(:article, :created_at => Time.now - 2.day,
        :allow_pings => true, :published => true)
      FactoryGirl.create(:trackback, :article => article, :published_at => Time.now - 1.day,
        :published => true)
      FactoryGirl.create(:trackback, :article => article_before, :published_at => Time.now - 3.day,
        :published => true)
      args = [ 1, 'henri', 'whatever', 2 ]
      result = invoke_layered :metaWeblog, :getRecentPosts, *args
      assert_equal result.size, 2
      assert_equal result.last['title'], Article.find(:first, :offset => 1, :order => 'created_at desc').title
    end

    it "test_meta_weblog_delete_post" do
      art_id = FactoryGirl.create(:article).id
      args = [ 1, art_id, 'henri', 'whatever', 1 ]

      result = invoke_layered :metaWeblog, :deletePost, *args
      assert_raise(ActiveRecord::RecordNotFound) { Article.find(art_id) }
    end

    describe "when editing a post" do
      before do
        @article = FactoryGirl.create(:article)
        @art_id = @article.id
        @article.title = "Modified!"
        @article.body = "this is a *test*"
        @article.text_filter = TextFilter.find_by_name("textile")
        @article.published_at = Time.now.utc.midnight

        @dto = MetaWeblog::Service.new(@controller).article_dto_from(@article)
      end

      it "test_meta_weblog_edit_post" do
        args = [ @art_id, 'henri', 'whatever', @dto, 1 ]

        result = invoke_layered :metaWeblog, :editPost, *args
        assert result

        new_article = Article.find(@art_id)

        assert_equal @article.title, new_article.title
        assert_equal @article.body, new_article.body
        assert_equal "<p>this is a <strong>test</strong></p>", new_article.html(:body)
        assert_equal @article.published_at, new_article.published_at.utc
      end

    end

    # TODO: Work out what the correct response is when a post can't be saved...
    it "test_meta_weblog_new_post_fails" do
      @article = Article.new(:title => 'test', :body => 'body', :extended => 'extended',
                             :text_filter => TextFilter.find_by_name('textile'),
                             :published_at => Time.now.utc.midnight)
      @article.errors.add(:base, 'test error')
      @article.should_receive(:save).and_return(false)
      Article.stub(:new).and_return(@article)
      args = [1, 'henri', 'whatever', MetaWeblog::Service.new(@controller).article_dto_from(@article), 1]
      lambda { invoke_layered :metaWeblog , :newPost, *args }.should \
        raise_error(XMLRPC::FaultException,
                    'Internal server error (exception raised)')
    end

    it "test_meta_weblog_new_post" do
      article = Article.new
      article.title = "Posted via Test"
      article.body = "body"
      article.extended = "extend me"
      article.text_filter = TextFilter.find_by_name("textile")
      article.published_at = Time.now.utc.midnight

      args = [ 1, 'henri', 'whatever', MetaWeblog::Service.new(@controller).article_dto_from(article), 1 ]

      result = invoke_layered :metaWeblog, :newPost, *args
      assert result
      new_post = Article.find(result)

      assert_equal "Posted via Test", new_post.title
      assert_equal "textile", new_post.text_filter.name
      assert_equal article.body, new_post.body
      assert_equal "<p>body</p>", new_post.html(:body)
      assert_equal article.extended, new_post.extended
      assert_equal "<p>extend me</p>", new_post.html(:extended)
      assert_equal article.published_at, new_post.published_at.utc
    end

    it "test_meta_weblog_new_unpublished_post_with_blank_creation_date" do
      dto = MetaWeblog::Structs::Article.new(:description => "Some text", :title => "A Title")
      args = [ 1, 'henri', 'whatever', dto, 0 ]
      result = invoke_layered :metaWeblog, :newPost, *args
      assert result
      new_post = Article.find(result)
      new_post.should_not be_published
    end

    it "test_meta_weblog_edit_unpublished_post_with_old_creation_date" do
      article = Article.new
      article.title = "Posted via Test"
      article.body = "body"
      article.extended = "extend me"
      article.text_filter = TextFilter.find_by_name("textile")
      article.published_at = Time.now - 1.days

      args = [ 1, 'henri', 'whatever', MetaWeblog::Service.new(@controller).article_dto_from(article), 0 ]

      result = invoke_layered :metaWeblog, :newPost, *args
      assert result
      new_post = Article.find(result)
      new_post.should_not be_published
    end

    it "test_meta_weblog_new_media_object" do
      media_object = MetaWeblog::Structs::MediaObject.new(
        "name" => Digest::SHA1.hexdigest("upload-test--#{Time.now}--") + ".gif",
        "type" => "image/gif",
          'bits' => Base64.encode64((::Rails.root + 'app' + 'assets' + 'images' + 'powered.gif').read)
      )

      args = [ 1, 'henri', 'whatever', media_object ]

      result = invoke_layered :metaWeblog, :newMediaObject, *args

      assert result['url'] =~ /#{media_object['name']}/
        #assert File.unlink(File.expand_path(::Rails.root.to_s) + "/public/files/#{media_object['name']}")
    end

    it "test_meta_weblog_fail_authentication" do
      args = [ 1, 'henri', 'using a wrong password', 2 ]
      # This will be a little more useful with the upstream changes in [1093]
      assert_raise(XMLRPC::FaultException) { invoke_layered :metaWeblog, :getRecentPosts, *args }
    end

    it "test_meta_weblog_should_preserve_date_time_on_roundtrip_edit" do
      # The XML-RPC spec and the MetaWeblog API are ambiguous about how to
      # intrepret the timezone in the dateCreated field.  But _however_ we
      # interpret it, we want to be able to fetch an article from the server,
      # edit it, and write it back to the server without changing its
      # dateCreated field.
      article = FactoryGirl.create(:article)
      original_published_at = article.published_at

      args = [ article.id, 'henri', 'whatever' ]
      result = invoke_layered :metaWeblog, :getPost, *args
      assert_equal original_published_at, result['dateCreated'].to_time

      args = [ article.id, 'henri', 'whatever', result, 1 ]
      result = invoke_layered :metaWeblog, :editPost, *args
      article.reload.published_at.should eq original_published_at
    end
  end

  describe "when called through the Movable Type API" do
    it "test_mt_get_recent_post_titles" do
      article = FactoryGirl.create(:article, :created_at => Time.now - 1.day,
        :allow_pings => true, :published => true)
      FactoryGirl.create(:trackback, :article => article, :published_at => Time.now - 1.day,
        :published => true)
      args = [ 1, 'henri', 'whatever', 2 ]
      result = invoke_layered :mt, :getRecentPostTitles, *args
      assert_equal result.first['title'], article.title
    end

    it "test_mt_supported_text_filters" do
      result = invoke_layered :mt, :supportedTextFilters
      assert result.map {|f| f['label']}.include?('Markdown')
      assert result.map {|f| f['label']}.include?('Textile')
    end

    it "test_mt_supported_methods" do
      result = invoke_layered :mt, :supportedMethods
      assert_equal 5, result.size
      assert result.include?("publishPost")
    end

    it "test_mt_get_trackback_pings" do
      article = FactoryGirl.create(:article, :created_at => Time.now - 1.day,
        :allow_pings => true, :published => true)
      FactoryGirl.create(:trackback, :article => article, :published_at => Time.now - 1.day,
        :published => true)

      args = [ article.id ]
      result = invoke_layered :mt, :getTrackbackPings, *args
      assert_equal result.first['pingTitle'], 'Trackback Entry'
    end

    it "should publish post" do
      art = FactoryGirl.create(:article,
        :published => false,
        :state => 'draft',
        :created_at => '2004-06-01 20:00:01',
        :updated_at => '2004-06-01 20:00:01',
        :published_at => '2004-06-01 20:00:01')

      args = [ art.id, 'henri', 'whatever' ]
      assert (not Article.find(art.id).published?)
      result = invoke_layered :mt, :publishPost, *args
      assert result
      assert Article.find(art.id).published?
      assert Article.find(art.id)[:published_at]
    end

    it "test_mt_fail_authentication" do
      args = [ 1, 'henri', 'using a wrong password', 2 ]
      # This will be a little more useful with the upstream changes in [1093]
      assert_raise(XMLRPC::FaultException) { invoke_layered :mt, :getRecentPostTitles, *args }
    end
  end
end
