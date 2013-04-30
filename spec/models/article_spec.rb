# coding: utf-8
require 'spec_helper'

describe Article do

  before do
    @blog = build_stubbed :blog
    @articles = []
  end

  def assert_results_are(*expected)
    assert_equal expected.size, @articles.size
    expected.each do |i|
      assert @articles.include?(i.is_a?(Symbol) ? contents(i) : i)
    end
  end

  it "test_content_fields" do
    a = Article.new
    assert_equal [:body, :extended], a.content_fields
  end

  describe "#permalink_url" do
    describe "with hostname" do
      subject { Article.new(:permalink => 'article-3', :published_at => Time.utc(2004, 6, 1)).permalink_url(anchor=nil, only_path=false) }
      it { should == 'http://myblog.net/2004/06/01/article-3' }
    end

    describe "without hostname" do
      subject { Article.new(:permalink => 'article-3', :published_at => Time.utc(2004, 6, 1)).permalink_url(anchor=nil, only_path=true) }
      it { should == '/2004/06/01/article-3' }
    end

    # NOTE: URLs must not have any multibyte characters in them. The
    # browser may display them differently, though.
    describe "with a multibyte permalink" do
      subject { Article.new(:permalink => 'ルビー', :published_at => Time.utc(2004, 6, 1)) }
      it "escapes the multibyte characters" do
        subject.permalink_url(anchor=nil, only_path=true).should == '/2004/06/01/%E3%83%AB%E3%83%93%E3%83%BC'
      end
    end

    describe "with a permalink containing a space" do
      subject { Article.new(:permalink => 'hello there', :published_at => Time.utc(2004, 6, 1)) }
      it "escapes the space as '%20', not as '+'" do
        subject.permalink_url(anchor=nil, only_path=true).should == '/2004/06/01/hello%20there'
      end
    end

    describe "with a permalink containing a plus" do
      subject { Article.new(:permalink => 'one+two', :published_at => Time.utc(2004, 6, 1)) }
      it "does not escape the plus" do
        subject.permalink_url(anchor=nil, only_path=true).should == '/2004/06/01/one+two'
      end
    end
  end

  describe "#initialize" do
    it "accepts a settings field in its parameter hash" do
      Article.new({"password" => 'foo'})
    end
  end

  describe ".feed_url" do
    let(:article) { FactoryGirl.build(:article, permalink: 'article-3', published_at: Time.utc(2004, 6, 1)) }

    it "returns url for atom feed for a Atom 1.0 asked" do
      article.feed_url('atom10').should eq "http://myblog.net/2004/06/01/article-3.atom"
    end

    it "returns url for rss feed for a RSS 2 asked" do
      article.feed_url('rss20').should eq "http://myblog.net/2004/06/01/article-3.rss"
    end
  end

  it "test_create" do
    a = Article.new
    a.user_id = 1
    a.body = "Foo"
    a.title = "Zzz"
    assert a.save

    a.categories << Category.find(FactoryGirl.create(:category).id)
    assert_equal 1, a.categories.size

    b = Article.find(a.id)
    assert_equal 1, b.categories.size
  end

  it "test_permalink_with_title" do
    article = FactoryGirl.create(:article, :permalink => 'article-3', :published_at => Time.utc(2004, 6, 1))
    assert_equal(article,
                 Article.find_by_permalink({:year => 2004, :month => 06, :day => 01, :title => "article-3"}) )
    assert_raises(ActiveRecord::RecordNotFound) do
      Article.find_by_permalink :year => 2005, :month => "06", :day => "01", :title => "article-5"
    end
  end

  it "test_strip_title" do
    assert_equal "article-3", "Article-3".to_url
    assert_equal "article-3", "Article 3!?#".to_url
    assert_equal "there-is-sex-in-my-violence", "There is Sex in my Violence!".to_url
    assert_equal "article", "-article-".to_url
    assert_equal "lorem-ipsum-dolor-sit-amet-consectetaur-adipisicing-elit", "Lorem ipsum dolor sit amet, consectetaur adipisicing elit".to_url
    assert_equal "my-cats-best-friend", "My Cat's Best Friend".to_url
  end

  describe "#stripped_title" do
    it "works for simple cases" do
      assert_equal "article-1", Article.new(:title => 'Article 1!').title.to_permalink
      assert_equal "article-2", Article.new(:title => 'Article 2!').title.to_permalink
      assert_equal "article-3", Article.new(:title => 'Article 3!').title.to_permalink
    end

    it "strips html" do
      a = Article.new(:title => "This <i>is</i> a <b>test</b>")
      assert_equal 'this-is-a-test', a.title.to_permalink
    end

    it "does not escape multibyte characters" do
      a = Article.new(:title => "ルビー")
      a.title.to_permalink.should == "ルビー"
    end

    it "is called upon saving the article" do
      a = Article.new(:title => "space separated")
      a.permalink.should be_nil
      a.save
      a.permalink.should == "space-separated"
    end
  end

  describe "the html_urls method" do
    before do
      @blog.stub(:text_filter_object) { TextFilter.new(:filters => []) }
      @article = Article.new
    end

    it "extracts URLs from the generated body html" do
      @article.body = 'happy halloween <a href="http://www.example.com/public">with</a>'
      urls = @article.html_urls
      assert_equal ["http://www.example.com/public"], urls
    end

    it "should only match the href attribute" do
      @article.body = '<a href="http://a/b">a</a> <a fhref="wrong">wrong</a>'
      urls = @article.html_urls
      assert_equal ["http://a/b"], urls
    end

    it "should match across newlines" do
      @article.body = "<a\nhref=\"http://foo/bar\">foo</a>"
      urls = @article.html_urls
      assert_equal ["http://foo/bar"], urls
    end

    it "should match with single quotes" do
      @article.body = "<a href='http://foo/bar'>foo</a>"
      urls = @article.html_urls
      assert_equal ["http://foo/bar"], urls
    end

    it "should match with no quotes" do
      @article.body = "<a href=http://foo/bar>foo</a>"
      urls = @article.html_urls
      assert_equal ["http://foo/bar"], urls
    end
  end

  ### XXX: Should we have a test here?
  it "test_send_pings" do
  end

  ### XXX: Should we have a test here?
  it "test_send_multiple_pings" do
  end

  describe "Testing redirects" do
    it "a new published article gets a redirect" do
      a = Article.create(:title => "Some title", :body => "some text", :published => true)
      a.redirects.first.should_not be_nil
      a.redirects.first.to_path.should == a.permalink_url
    end

    it "a new unpublished article should not get a redirect" do
      a = Article.create(:title => "Some title", :body => "some text", :published => false)
      a.redirects.first.should be_nil
    end

    it "Changin a published article permalink url should only change the to redirection" do
      a = Article.create(:title => "Some title", :body => "some text", :published => true)
      a.redirects.first.should_not be_nil
      a.redirects.first.to_path.should == a.permalink_url
      r  = a.redirects.first.from_path

      a.permalink = "some-new-permalink"
      a.save
      a.redirects.first.should_not be_nil
      a.redirects.first.to_path.should == a.permalink_url
      a.redirects.first.from_path.should == r
    end
  end

  describe "with tags" do
    it "recieves tags from the keywords property" do
      a = FactoryGirl.create(:article, :keywords => 'foo bar')
      assert_equal ['foo', 'bar'].sort, a.tags.collect {|t| t.name}.sort
    end

    it "changes tags when changing keywords" do
      a = FactoryGirl.create(:article, :keywords => 'foo bar')
      a.keywords = 'foo baz'
      a.save
      assert_equal ['foo', 'baz'].sort, a.tags.collect {|t| t.name}.sort
    end

    it "empties tags when keywords is set to ''" do
      a = FactoryGirl.create(:article, :keywords => 'foo bar')
      a.keywords = ''
      a.save
      assert_equal [], a.tags.collect {|t| t.name}.sort
    end

    it "properly deals with dots and spaces" do
      c = FactoryGirl.create(:article, :keywords => 'test "tag test" web2.0')
      assert_equal ['test', 'tag-test', 'web2-0'].sort, c.tags.collect(&:name).sort
    end

    # TODO: Get rid of using the keywords field.
    # TODO: Add functions to Tag to convert collection from and to string.
    it "lets the tag collection survive a load-save cycle"
  end

  it "test_find_published_by_tag_name" do
    art1 = FactoryGirl.create(:article)
    art2 = FactoryGirl.create(:article)
    FactoryGirl.create(:tag, :name => 'foo', :articles => [art1, art2])
    articles = Tag.find_by_name('foo').published_articles
    assert_equal 2, articles.size
  end

  it "test_find_published" do
    article = FactoryGirl.create(:article, :title => 'Article 1!', :state => 'published')
    FactoryGirl.create(:article, :published => false, :state => 'draft')
    @articles = Article.find_published
    assert_equal 1, @articles.size
    @articles = Article.find_published(:all, :conditions => "title = 'Article 1!'")
    assert_equal [article], @articles
  end

  it "test_just_published_flag" do

    art = Article.new(:title => 'title', :body => 'body', :published => true)

    assert art.just_changed_published_status?
    assert art.save

    art = Article.find(art.id)
    assert !art.just_changed_published_status?

    art = Article.create!(:title => 'title2', :body => 'body', :published => false)

    assert ! art.just_changed_published_status?
  end

  it "test_future_publishing" do
    assert_sets_trigger(Article.create!(:title => 'title', :body => 'body',
                                        :published => true, :published_at => Time.now + 4.seconds))
  end

  it "test_future_publishing_without_published_flag" do
    assert_sets_trigger Article.create!(:title => 'title', :body => 'body',
                                        :published_at => Time.now + 4.seconds)
  end

  it "test_triggers_are_dependent" do
    pending "Needs a fix for Rails ticket #5105: has_many: Dependent deleting does not work with STI"
    art = Article.create!(:title => 'title', :body => 'body',
                          :published_at => Time.now + 1.hour)
    assert_equal 1, Trigger.count
    art.destroy
    assert_equal 0, Trigger.count
  end

  def assert_sets_trigger(art)
    assert_equal 1, Trigger.count
    assert Trigger.find(:first, :conditions => ['pending_item_id = ?', art.id])
    assert !art.published
    t = Time.now
    # We stub the Time.now answer to emulate a sleep of 4. Avoid the sleep. So
    # speed up in test
    Time.stub(:now).and_return(t + 5.seconds)
    Trigger.fire
    art.reload
    assert art.published
  end

  it "test_find_published_by_category" do
    cat = FactoryGirl.create(:category, :permalink => 'personal')
    cat.articles << FactoryGirl.create(:article)
    cat.articles << FactoryGirl.create(:article)
    cat.articles << FactoryGirl.create(:article)

    cat = FactoryGirl.create(:category, :permalink => 'software')
    cat.articles << FactoryGirl.create(:article)

    Article.create!(:title      => "News from the future!",
                    :body       => "The future is cool!",
                    :keywords   => "future",
                    :published_at => Time.now + 12.minutes)

    articles = Category.find_by_permalink('personal').published_articles
    assert_equal 3, articles.size

    articles = Category.find_by_permalink('software').published_articles
    assert_equal 1, articles.size
  end

  it "test_find_published_by_nonexistent_category_raises_exception" do
    assert_raises ActiveRecord::RecordNotFound do
      Category.find_by_permalink('does-not-exist').published_articles
    end
  end

  it "test_destroy_file_upload_associations" do
    a = FactoryGirl.create(:article)
    FactoryGirl.create(:resource, :article => a)
    FactoryGirl.create(:resource, :article => a)
    assert_equal 2, a.resources.size
    a.resources << FactoryGirl.create(:resource)
    assert_equal 3, a.resources.size
    a.destroy
    assert_equal 0, Resource.find(:all, :conditions => "article_id = #{a.id}").size
  end

  describe "#interested_users" do
    it 'should gather users interested in new articles' do
      henri = FactoryGirl.create(:user, :login => 'henri', :notify_on_new_articles => true)
      alice = FactoryGirl.create(:user, :login => 'alice', :notify_on_new_articles => true)

      a = FactoryGirl.build(:article)
      users = a.interested_users
      logins = users.map {|u| u.login}.sort
      logins.should eq ['alice', 'henri']
    end
  end

  it "test_withdrawal" do
    art = FactoryGirl.create(:article)
    assert   art.published?
    assert ! art.withdrawn?
    art.withdraw!
    assert ! art.published?
    assert   art.withdrawn?
    art.reload
    assert ! art.published?
    assert   art.withdrawn?
  end

  describe "#default_text_filter" do
    it "returns the blog's text filter" do
      a = Article.new
      assert_equal @blog.text_filter, a.default_text_filter.name
    end
  end

  it 'should get only ham not spam comment' do
    article = FactoryGirl.create(:article)
    article.stub(:allow_comments?).and_return(true)
    ham_comment = FactoryGirl.create(:comment, :article => article)
    spam_comment = FactoryGirl.create(:spam_comment, :article => article)
    article.comments.ham.should == [ham_comment]
    article.comments.count.should == 2
  end

  describe '#access_by?' do
    before do
      @alice = FactoryGirl.build(:user, :profile => FactoryGirl.build(:profile_admin, :label => Profile::ADMIN))
    end

    it 'admin should have access to an article written by another' do
      FactoryGirl.build(:article).should be_access_by(@alice)
    end

    it 'admin should have access to an article written by himself' do
      article = FactoryGirl.build(:article, :author => @alice)
      article.should be_access_by(@alice)
    end

  end

  describe 'body_and_extended' do
    before :each do
      @article = Article.new(
        :body => 'basic text',
        :extended => 'extended text to explain more and more how Typo is wonderful')
    end

    it 'should combine body and extended content' do
      @article.body_and_extended.should ==
        "#{@article.body}\n<!--more-->\n#{@article.extended}"
    end

    it 'should not insert <!--more--> tags if extended is empty' do
      @article.extended = ''
      @article.body_and_extended.should == @article.body
    end
  end

  describe '#search' do

    describe 'with several words and no result' do

      # FIXME: This tests nothing, really.
      before :each do
        @articles = Article.search('hello world')
      end

      it 'should be empty' do
        @articles.should be_empty
      end
    end

    describe 'with one word and result' do
      it 'should have two items' do
        FactoryGirl.create(:article, :extended => "extended talk")
        FactoryGirl.create(:article, :extended => "Once uppon a time, an extended story")
        assert_equal 2, Article.search('extended').size
      end
    end
  end

  describe 'body_and_extended=' do
    before :each do
      @article = Article.new
    end

    it 'should split apart values at <!--more-->' do
      @article.body_and_extended = 'foo<!--more-->bar'
      @article.body.should == 'foo'
      @article.extended.should == 'bar'
    end

    it 'should remove newlines around <!--more-->' do
      @article.body_and_extended = "foo\n<!--more-->\nbar"
      @article.body.should == 'foo'
      @article.extended.should == 'bar'
    end

    it 'should make extended empty if no <!--more--> tag' do
      @article.body_and_extended = "foo"
      @article.body.should == 'foo'
      @article.extended.should be_empty
    end

    it 'should preserve extra <!--more--> tags' do
      @article.body_and_extended = "foo<!--more-->bar<!--more-->baz"
      @article.body.should == 'foo'
      @article.extended.should == 'bar<!--more-->baz'
    end

    it 'should be settable via self.attributes=' do
      @article.attributes = { :body_and_extended => 'foo<!--more-->bar' }
      @article.body.should == 'foo'
      @article.extended.should == 'bar'
    end
  end

  describe '#comment_url' do
    it 'should render complete url of comment' do
      article = stub_model(Article, :id => 123)
      article.comment_url.should == "/comments?article_id=#{article.id}"
    end
  end

  describe '#preview_comment_url' do
    it 'should render complete url of comment' do
      article = stub_model(Article, :id => 123)
      article.preview_comment_url.should == "/comments/preview?article_id=#{article.id}"
    end
  end

  it "test_can_ping_fresh_article_iff_it_allows_pings" do
    a = FactoryGirl.create(:article, :allow_pings => true)
    assert_equal(false, a.pings_closed?)
    a.allow_pings = false
    assert_equal(true, a.pings_closed?)
  end

  it "test_cannot_ping_old_article" do
    a = FactoryGirl.create(:article, :allow_pings => false)
    assert_equal(true, a.pings_closed?)
    a.allow_pings = false
    assert_equal(true, a.pings_closed?)
  end

  describe '#published_at_like' do
    before do
      # Note: these choices of times depend on no other articles within
      # these timeframes existing in test/fixtures/contents.yaml.
      # In particular, all articles there are from 2005 or earlier, which
      # is now more than two years ago, except for two, which are from
      # yesterday and the day before. The existence of those two makes
      # 1.month.ago not suitable, because yesterday can be last month.
      @article_two_month_ago = FactoryGirl.create(:article, :published_at => 2.month.ago)

      @article_four_months_ago = FactoryGirl.create(:article, :published_at => 4.month.ago)
      @article_2_four_months_ago = FactoryGirl.create(:article, :published_at => 4.month.ago)

      @article_two_year_ago = FactoryGirl.create(:article, :published_at => 2.year.ago)
      @article_2_two_year_ago = FactoryGirl.create(:article, :published_at => 2.year.ago)
    end

    it 'should return all content for the year if only year sent' do
      Article.published_at_like(2.year.ago.strftime('%Y')).map(&:id).sort.should == [@article_two_year_ago.id, @article_2_two_year_ago.id].sort
    end

    it 'should return all content for the month if year and month sent' do
      Article.published_at_like(4.month.ago.strftime('%Y-%m')).map(&:id).sort.should == [@article_four_months_ago.id, @article_2_four_months_ago.id].sort
    end

    it 'should return all content on this date if date send' do
      Article.published_at_like(2.month.ago.strftime('%Y-%m-%d')).map(&:id).sort.should == [@article_two_month_ago.id].sort
    end
  end

  describe '#has_child?' do
    it 'should be true if article has one to link it by parent_id' do
      parent = FactoryGirl.create(:article)
      FactoryGirl.create(:article, :parent_id => parent.id)
      parent.should be_has_child
    end
    it 'should be false if article has no article to link it by parent_id' do
      parent = FactoryGirl.create(:article)
      FactoryGirl.create(:article, :parent_id => nil)
      parent.should_not be_has_child
    end
  end

  describe 'self#last_draft(id)' do
    it 'should return article if no draft associated' do
      draft = FactoryGirl.create(:article, :state => 'draft')
      Article.last_draft(draft.id).should == draft
    end
    it 'should return draft associated to this article if there are one' do
      parent = FactoryGirl.create(:article)
      draft = FactoryGirl.create(:article, :parent_id => parent.id, :state => 'draft')
      Article.last_draft(draft.id).should == draft
    end
  end

  describe "an article published just before midnight UTC" do
    before do
      @a = FactoryGirl.build(:article)
      @a.published_at = "21 Feb 2011 23:30 UTC"
    end

    describe "#permalink_url" do
      it "uses UTC to determine correct day" do
        @a.permalink_url.should == "http://myblog.net/2011/02/21/a-big-article"
      end
    end

    describe "#find_by_permalink" do
      it "uses UTC to determine correct day" do
        @a.save
        a = Article.find_by_permalink :year => 2011, :month => 2, :day => 21, :permalink => 'a-big-article'
        a.should == @a
      end
    end
  end

  describe "an article published just after midnight UTC" do
    before do
      @a = FactoryGirl.build(:article)
      @a.published_at = "22 Feb 2011 00:30 UTC"
    end

    describe "#permalink_url" do
      it "uses UTC to determine correct day" do
        @a.permalink_url.should == "http://myblog.net/2011/02/22/a-big-article"
      end
    end

    describe "#find_by_permalink" do
      it "uses UTC to determine correct day" do
        @a.save
        a = Article.find_by_permalink :year => 2011, :month => 2, :day => 22, :permalink => 'a-big-article'
        a.should == @a
      end
    end
  end

  describe "#published_comments" do
    it 'should not include withdrawn comments' do
      a = Article.new(title: 'foo')
      a.save!

      assert_equal 0, a.published_comments.size
      c = a.comments.build(body: 'foo', author: 'bob', published: true, published_at: Time.now)
      assert c.published?
      c.save!
      a.reload

      assert_equal 1, a.published_comments.size
      c.withdraw!
      assert_equal 0, a.published_comments.size
    end
  end

  describe "save_attachments!" do
    it "calls save_attachment for each file given" do
      first_file = OpenStruct.new
      second_file = OpenStruct.new
      hash = {a_key: first_file, a_second_key: second_file}
      article = FactoryGirl.build(:article)
      article.should_receive(:save_attachment!).with(first_file)
      article.should_receive(:save_attachment!).with(second_file)
      article.save_attachments!(hash)
    end

    it "do nothing with nil given" do
      article = FactoryGirl.build(:article)
      article.save_attachments!(nil)
    end
  end

  describe "save_attachment!" do
    it "calls resource create_and_upload and add this new resource" do
      resource = FactoryGirl.build(:resource)
      file = OpenStruct.new
      article = FactoryGirl.create(:article)
      Resource.should_receive(:create_and_upload).with(file).and_return(resource)
      article.save_attachment!(file).reload
      article.resources.should eq [resource]
    end
  end

  describe ".really_send_pings" do
    context "given a new article" do
      let(:article) { Article.new }

      it "return nil and do nothing when blog should not send_outbound_pings" do
        Blog.any_instance.should_receive(:send_outbound_pings).and_return(false)
        article.really_send_pings.should be_nil
      end

      context "given a blog that allow send outbound pings" do
        before(:each) do
          Blog.any_instance.should_receive(:send_outbound_pings).and_return(true)
        end

        it "do nothing when no urls to ping article" do
          Blog.any_instance.should_receive(:urls_to_ping_for).and_return([])
          article.should_receive(:html_urls_to_ping).and_return([])
          Ping.any_instance.should_not_receive(:send_weblogupdatesping)
          Ping.any_instance.should_not_receive(:send_pingback_or_trackback)
          article.really_send_pings
        end

        it "do nothing when urls already list in article.pings (already ping ?)"  do
          ping = OpenStruct.new(url: "an_url_to_ping")
          Blog.any_instance.should_receive(:urls_to_ping_for).and_return([ping])
          article.should_receive(:html_urls_to_ping).and_return(['an_url_to_ping'])
          Ping.any_instance.should_not_receive(:send_weblogupdatesping)
          Ping.any_instance.should_not_receive(:send_pingback_or_trackback)
          article.really_send_pings
        end

        it "calls send_weblogupdatesping when it's not already done"  do
          new_ping = OpenStruct.new
          urls_to_ping = [new_ping]
          Blog.any_instance.should_receive(:urls_to_ping_for).and_return(urls_to_ping)
          article.should_receive(:permalink_url)
          article.should_receive(:html_urls_to_ping).and_return([])
          new_ping.should_receive(:send_weblogupdatesping)
          new_ping.should_not_receive(:send_pingback_or_trackback)
          article.really_send_pings
        end

        it "calls send_pingback_or_trackback when it's not already done"  do
          Blog.any_instance.should_receive(:urls_to_ping_for).and_return([])
          new_ping = OpenStruct.new
          article.should_receive(:html_urls_to_ping).and_return([new_ping])
          article.should_receive(:permalink_url)
          new_ping.should_receive(:send_pingback_or_trackback)
          new_ping.should_not_receive(:send_weblogupdatesping)
          article.really_send_pings
        end
      end
    end
  end

  describe ".search_with_pagination" do
    #TODO move those kind of test to a "integration specs" that can be run only for integration
    context "given some datas" do
      it "returns an empty array when no article and no params" do
        Article.search_with_pagination({}, {page: nil, per_page: 12}).should be_empty
      end

      it "returns article" do
        article = FactoryGirl.create(:article)
        Article.search_with_pagination({}, {page: nil, per_page: 12}).should eq([article])
      end

      it "returns only published article where search params ask about published state" do
        published_article = FactoryGirl.create(:article, state: 'published')
        article = FactoryGirl.create(:article, state: 'draft')
        Article.search_with_pagination({state: 'published'}, {page: nil, per_page: 12}).should eq([published_article])
      end

      it "returns only quantity of article ask in per_page" do
        article = FactoryGirl.create(:article, state: 'published')
        out_of_per_page_article = FactoryGirl.create(:article, state: 'draft')

        Article.search_with_pagination({}, { page: nil, per_page: 1 }).should have(1).item
      end

      it "returns both published and draft articles by default" do
        article = FactoryGirl.create(:article, state: 'published')
        draft_article = FactoryGirl.create(:article, state: 'draft')
        result = Article.search_with_pagination({}, {page: nil, per_page: 12})
        result.count.should eq 2
      end

      it "returns article of search categorie" do
        show_category = FactoryGirl.create(:category, name: 'show')
        hide_category = FactoryGirl.create(:category, name: 'not_show')
        article = FactoryGirl.create(:article, categories: [show_category])
        hide_article = FactoryGirl.create(:article, categories: [hide_category])
        Article.search_with_pagination({category: show_category.id}, {page: nil, per_page: 12}).should eq([article])
      end

    end
  end

  describe ".allow_comments?" do
    it "true if article set to true" do
      Article.new(allow_comments: true).allow_comments?.should be_true
    end

    it "false if article set to false" do
      Article.new(allow_comments: false).allow_comments?.should be_false
    end

    context "given an article with no allow comments state" do
      it "returns true when blog default allow comments is true" do
        Blog.any_instance.should_receive(:default_allow_comments).and_return(true)
        Article.new(allow_comments: nil).allow_comments?.should be_true
      end

      it "returns false when blog default allow comments is true" do
        Blog.any_instance.should_receive(:default_allow_comments).and_return(false)
        Article.new(allow_comments: nil).allow_comments?.should be_false
      end
    end
  end

  describe ".allow_pings?" do
    it "true if article set to true" do
      Article.new(allow_pings: true).allow_pings?.should be_true
    end

    it "false if article set to false" do
      Article.new(allow_pings: false).allow_pings?.should be_false
    end

    context "given an article with no allow pings state" do
      it "returns true when blog default allow pings is true" do
        Blog.any_instance.should_receive(:default_allow_pings).and_return(true)
        Article.new(allow_pings: nil).allow_pings?.should be_true
      end

      it "returns false when blog default allow pings is true" do
        Blog.any_instance.should_receive(:default_allow_pings).and_return(false)
        Article.new(allow_pings: nil).allow_pings?.should be_false
      end
    end

  end

  describe "#find_by_published_at" do
    it "returns an empty array when no articles" do
      Article.find_by_published_at.should be_empty
    end

    context "returns objects that respond to publication with YYYY-MM published_at date format" do
      it "with article published_at date" do
        FactoryGirl.create(:article, published_at: Date.new(2010, 11, 23))
        result = Article.find_by_published_at
        result.count.should eq 1
        result.first.should eq ["2010-11"]
      end

      it "with 2 articles" do
        FactoryGirl.create(:article, published_at: Date.new(2010, 11, 23))
        FactoryGirl.create(:article, published_at: Date.new(2002, 4, 9))
        result = Article.find_by_published_at
        result.count.should eq 2
        result.sort.should eq [["2010-11"], ["2002-04"]].sort
      end
    end

  end

  describe "published_since" do
    let(:time) { DateTime.new(2010,11,3,23,34) }
    it "empty when no articles" do
      Article.published_since(time).should be_empty
    end

    it "returns article that was published since" do
      article = FactoryGirl.create(:article, published_at: time + 2.hours)
      Article.published_since(time).should eq [article]
    end

    it "returns only article that was published since last visit" do
      already_seen_article = FactoryGirl.create(:article, published_at: time - 2.hours)
      article = FactoryGirl.create(:article, published_at: time + 2.hours)
      Article.published_since(time).should eq [article]
    end
  end

  describe "bestof" do
    it "returns empty array when no content" do
      expect(Article.bestof).to be_empty
    end

    it "returns article with comment count field" do
      comment = FactoryGirl.create(:comment)
      article = comment.article
      expect(Article.bestof.first.comment_count.to_i).to eq 1
    end

    it "counts comments but not trackbacks" do
      article = create :article
      create :trackback, article: article
      create_list :comment, 2, article: article

      expect(Article.bestof.first.comment_count.to_i).to eq 2
    end

    it "returns only 5 articles" do
      6.times { FactoryGirl.create(:comment) }
      expect(Article.bestof.length).to eq(5)
    end

    it "returns only published articles" do
      article = FactoryGirl.create(:article)
      FactoryGirl.create(:comment, article: article)
      unpublished_article = FactoryGirl.create(:article, published: false)
      FactoryGirl.create(:comment, article: unpublished_article)
      expect(Article.published).to eq([article])
      expect(Article.bestof).to eq([article])
    end

    it "returns article sorted by comment counts" do
      last_article = FactoryGirl.create(:article)
      FactoryGirl.create(:comment, article: last_article)

      first_article = FactoryGirl.create(:article)
      FactoryGirl.create(:comment, article: first_article)
      FactoryGirl.create(:comment, article: first_article)

      expect(Article.bestof).to eq([first_article, last_article])
    end
  end
end
