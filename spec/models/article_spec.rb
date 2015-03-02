# coding: utf-8
require 'rails_helper'

describe Article, type: :model do
  let!(:blog) { create(:blog) }

  it 'test_content_fields' do
    a = Article.new
    assert_equal [:body, :extended], a.content_fields
  end

  describe '#permalink_url' do
    describe 'with hostname' do
      subject { Article.new(permalink: 'article-3', published_at: Time.utc(2004, 6, 1)).permalink_url(nil, false) }
      it { is_expected.to eq('http://myblog.net/2004/06/01/article-3') }
    end

    describe 'without hostname' do
      subject { Article.new(permalink: 'article-3', published_at: Time.utc(2004, 6, 1)).permalink_url(nil, true) }
      it { is_expected.to eq('/2004/06/01/article-3') }
    end

    # NOTE: URLs must not have any multibyte characters in them. The
    # browser may display them differently, though.
    describe 'with a multibyte permalink' do
      subject { Article.new(permalink: 'ルビー', published_at: Time.utc(2004, 6, 1)) }
      it 'escapes the multibyte characters' do
        expect(subject.permalink_url(nil, true)).to eq('/2004/06/01/%E3%83%AB%E3%83%93%E3%83%BC')
      end
    end

    describe 'with a permalink containing a space' do
      subject { Article.new(permalink: 'hello there', published_at: Time.utc(2004, 6, 1)) }
      it "escapes the space as '%20', not as '+'" do
        expect(subject.permalink_url(nil, true)).to eq('/2004/06/01/hello%20there')
      end
    end

    describe 'with a permalink containing a plus' do
      subject { Article.new(permalink: 'one+two', published_at: Time.utc(2004, 6, 1)) }
      it 'does not escape the plus' do
        expect(subject.permalink_url(nil, true)).to eq('/2004/06/01/one+two')
      end
    end
  end

  describe '#initialize' do
    it 'accepts a settings field in its parameter hash' do
      Article.new('password' => 'foo')
    end
  end

  describe '.feed_url' do
    let(:article) { build(:article, permalink: 'article-3', published_at: Time.utc(2004, 6, 1)) }

    it 'returns url for atom feed for a Atom 1.0 asked' do
      expect(article.feed_url('atom10')).to eq 'http://myblog.net/2004/06/01/article-3.atom'
    end

    it 'returns url for rss feed for a RSS 2 asked' do
      expect(article.feed_url('rss20')).to eq 'http://myblog.net/2004/06/01/article-3.rss'
    end
  end

  it 'test_create' do
    a = Article.new
    a.user_id = 1
    a.body = 'Foo'
    a.title = 'Zzz'
    assert a.save

    a.tags << Tag.find(create(:tag).id)
    assert_equal 1, a.tags.size

    b = Article.find(a.id)
    assert_equal 1, b.tags.size
  end

  it 'test_permalink_with_title' do
    article = create(:article, permalink: 'article-3', published_at: Time.utc(2004, 6, 1))
    assert_equal(article, Article.find_by_permalink(year: 2004, month: 06, day: 01, title: 'article-3'))
    not_found = Article.find_by_permalink year: 2005, month: '06', day: '01', title: 'article-5'
    expect(not_found).to be_nil
  end

  it 'test_strip_title' do
    assert_equal 'article-3', 'Article-3'.to_url
    assert_equal 'article-3', 'Article 3!?#'.to_url
    assert_equal 'there-is-sex-in-my-violence', 'There is Sex in my Violence!'.to_url
    assert_equal 'article', '-article-'.to_url
    assert_equal 'lorem-ipsum-dolor-sit-amet-consectetaur-adipisicing-elit', 'Lorem ipsum dolor sit amet, consectetaur adipisicing elit'.to_url
    assert_equal 'my-cats-best-friend', "My Cat's Best Friend".to_url
  end

  describe '#stripped_title' do
    it 'works for simple cases' do
      assert_equal 'article-1', Article.new(title: 'Article 1!').title.to_permalink
      assert_equal 'article-2', Article.new(title: 'Article 2!').title.to_permalink
      assert_equal 'article-3', Article.new(title: 'Article 3!').title.to_permalink
    end

    it 'strips html' do
      a = Article.new(title: 'This <i>is</i> a <b>test</b>')
      assert_equal 'this-is-a-test', a.title.to_permalink
    end

    it 'does not escape multibyte characters' do
      a = Article.new(title: 'ルビー')
      expect(a.title.to_permalink).to eq('ルビー')
    end

    it 'is called upon saving the article' do
      a = Article.new(title: 'space separated')
      expect(a.permalink).to be_nil
      a.save
      expect(a.permalink).to eq('space-separated')
    end
  end

  describe 'the html_urls method' do
    before do
      allow(blog).to receive(:text_filter_object) { TextFilter.new(filters: []) }
      @article = Article.new
    end

    it 'extracts URLs from the generated body html' do
      @article.body = 'happy halloween <a href="http://www.example.com/public">with</a>'
      urls = @article.html_urls
      assert_equal ['http://www.example.com/public'], urls
    end

    it 'should only match the href attribute' do
      @article.body = '<a href="http://a/b">a</a> <a fhref="wrong">wrong</a>'
      urls = @article.html_urls
      assert_equal ['http://a/b'], urls
    end

    it 'should match across newlines' do
      @article.body = "<a\nhref=\"http://foo/bar\">foo</a>"
      urls = @article.html_urls
      assert_equal ['http://foo/bar'], urls
    end

    it 'should match with single quotes' do
      @article.body = "<a href='http://foo/bar'>foo</a>"
      urls = @article.html_urls
      assert_equal ['http://foo/bar'], urls
    end

    it 'should match with no quotes' do
      @article.body = '<a href=http://foo/bar>foo</a>'
      urls = @article.html_urls
      assert_equal ['http://foo/bar'], urls
    end
  end

  describe 'saving an Article' do
    context 'with a blog that sends outbound pings' do
      let(:referenced_url) { 'http://anotherblog.org/a-post' }
      let!(:blog) { create(:blog, send_outbound_pings: 1) }

      # FIXME: This spec is way too complex
      it 'sends a pingback to urls linked in the body' do
        expect(Thread.list.count).to eq 3

        expect(ActiveRecord::Base.observers).to include(:email_notifier)
        expect(ActiveRecord::Base.observers).to include(:web_notifier)
        a = Article.new(body: %(<a href="#{referenced_url}">),
                        title: 'Test the pinging',
                        published: true)

        mock_pinger = instance_double('Ping::Pinger')
        allow(Ping::Pinger).to receive(:new).
          with(%r{http://myblog.net/\d{4}/\d{2}/\d{2}/test-the-pinging}, Ping).
          and_return mock_pinger
        expect(mock_pinger).to receive(:send_pingback_or_trackback)

        expect(a.html_urls.size).to eq(1)
        a.save!

        10.times do
          break if Thread.list.count <= 3
          sleep 0.1
        end

        expect(a).to be_just_published
        a = Article.find(a.id)
        expect(a).not_to be_just_published
        # Saving again will not resend the pings
        a.save
      end
    end
  end

  describe 'Testing redirects' do
    it 'a new published article gets a redirect' do
      a = Article.create(title: 'Some title', body: 'some text', published: true)
      expect(a.redirects.first).not_to be_nil
      expect(a.redirects.first.to_path).to eq(a.permalink_url)
    end

    it 'a new unpublished article should not get a redirect' do
      a = Article.create(title: 'Some title', body: 'some text', published: false)
      expect(a.redirects.first).to be_nil
    end

    it 'Changin a published article permalink url should only change the to redirection' do
      a = Article.create(title: 'Some title', body: 'some text', published: true)
      expect(a.redirects.first).not_to be_nil
      expect(a.redirects.first.to_path).to eq(a.permalink_url)
      r  = a.redirects.first.from_path

      a.permalink = 'some-new-permalink'
      a.save
      expect(a.redirects.first).not_to be_nil
      expect(a.redirects.first.to_path).to eq(a.permalink_url)
      expect(a.redirects.first.from_path).to eq(r)
    end
  end

  it 'test_find_published_by_tag_name' do
    art1 = create(:article)
    art2 = create(:article)
    create(:tag, name: 'foo', articles: [art1, art2])
    articles = Tag.find_by_name('foo').published_articles
    assert_equal 2, articles.size
  end

  it 'test_just_published_flag' do
    art = Article.new(title: 'title', body: 'body', published: true)

    assert art.just_changed_published_status?
    assert art.save

    art = Article.find(art.id)
    assert !art.just_changed_published_status?

    art = Article.create!(title: 'title2', body: 'body', published: false)

    assert !art.just_changed_published_status?
  end

  it 'test_future_publishing' do
    assert_sets_trigger(Article.create!(title: 'title', body: 'body',
                                        published: true, published_at: Time.now + 4.seconds))
  end

  it 'test_future_publishing_without_published_flag' do
    assert_sets_trigger Article.create!(title: 'title', body: 'body',
                                        published_at: Time.now + 4.seconds)
  end
  it 'test_triggers_are_dependent' do
    # TODO: Needs a fix for Rails ticket #5105: has_many: Dependent deleting does not work with STI
    skip
    art = Article.create!(title: 'title', body: 'body',
                          published_at: Time.now + 1.hour)
    assert_equal 1, Trigger.count
    art.destroy
    assert_equal 0, Trigger.count
  end

  def assert_sets_trigger(art)
    assert_equal 1, Trigger.count
    assert Trigger.where(pending_item_id: art.id).first
    assert !art.published
    t = Time.now
    # We stub the Time.now answer to emulate a sleep of 4. Avoid the sleep. So
    # speed up in test
    allow(Time).to receive(:now).and_return(t + 5.seconds)
    Trigger.fire
    art.reload
    assert art.published
  end

  it 'test_destroy_file_upload_associations' do
    a = create(:article)
    create(:resource, article: a)
    create(:resource, article: a)
    assert_equal 2, a.resources.size
    a.resources << create(:resource)
    assert_equal 3, a.resources.size
    a.destroy
    assert_equal 0, Resource.where(article_id: a.id).size
  end

  describe '#interested_users' do
    it 'should gather users interested in new articles' do
      henri = create(:user, login: 'henri', notify_on_new_articles: true)
      alice = create(:user, login: 'alice', notify_on_new_articles: true)

      a = build(:article)
      users = a.interested_users
      expect(users).to match_array [alice, henri]
    end
  end

  it 'test_withdrawal' do
    art = create(:article)
    assert art.published?
    assert !art.withdrawn?
    art.withdraw!
    assert !art.published?
    assert art.withdrawn?
    art.reload
    assert !art.published?
    assert art.withdrawn?
  end

  it 'should get only ham not spam comment' do
    article = create(:article)
    ham_comment = create(:comment, article: article)
    create(:spam_comment, article: article)
    expect(article.comments.ham).to eq([ham_comment])
    expect(article.comments.count).to eq(2)
  end

  describe '#access_by?' do
    before do
      @alice = build(:user, profile: build(:profile_admin, label: Profile::ADMIN))
    end

    it 'admin should have access to an article written by another' do
      expect(build(:article)).to be_access_by(@alice)
    end

    it 'admin should have access to an article written by himself' do
      article = build(:article, author: @alice)
      expect(article).to be_access_by(@alice)
    end
  end

  describe 'body_and_extended' do
    before :each do
      @article = Article.new(
        body: 'basic text',
        extended: 'extended text to explain more and more how Publify is wonderful')
    end

    it 'should combine body and extended content' do
      expect(@article.body_and_extended).to eq(
        "#{@article.body}\n<!--more-->\n#{@article.extended}"
      )
    end

    it 'should not insert <!--more--> tags if extended is empty' do
      @article.extended = ''
      expect(@article.body_and_extended).to eq(@article.body)
    end
  end

  describe '#search' do
    describe 'with one word and result' do
      it 'should have two items' do
        create(:article, extended: 'extended talk')
        create(:article, extended: 'Once uppon a time, an extended story')
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
      expect(@article.body).to eq('foo')
      expect(@article.extended).to eq('bar')
    end

    it 'should remove newlines around <!--more-->' do
      @article.body_and_extended = "foo\n<!--more-->\nbar"
      expect(@article.body).to eq('foo')
      expect(@article.extended).to eq('bar')
    end

    it 'should make extended empty if no <!--more--> tag' do
      @article.body_and_extended = 'foo'
      expect(@article.body).to eq('foo')
      expect(@article.extended).to be_empty
    end

    it 'should preserve extra <!--more--> tags' do
      @article.body_and_extended = 'foo<!--more-->bar<!--more-->baz'
      expect(@article.body).to eq('foo')
      expect(@article.extended).to eq('bar<!--more-->baz')
    end

    it 'should be settable via self.attributes=' do
      @article.attributes = { body_and_extended: 'foo<!--more-->bar' }
      expect(@article.body).to eq('foo')
      expect(@article.extended).to eq('bar')
    end
  end

  describe '#comment_url' do
    it 'should render complete url of comment' do
      article = build_stubbed(:article, id: 123)
      expect(article.comment_url).to eq("/comments?article_id=#{article.id}")
    end
  end

  describe '#preview_comment_url' do
    it 'should render complete url of comment' do
      article = build_stubbed(:article, id: 123)
      expect(article.preview_comment_url).to eq("/comments/preview?article_id=#{article.id}")
    end
  end

  it 'test_can_ping_fresh_article_iff_it_allows_pings' do
    a = create(:article, allow_pings: true)
    assert_equal(false, a.pings_closed?)
    a.allow_pings = false
    assert_equal(true, a.pings_closed?)
  end

  it 'test_cannot_ping_old_article' do
    a = create(:article, allow_pings: false)
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
      @article_two_month_ago = create(:article, published_at: 2.month.ago)

      @article_four_months_ago = create(:article, published_at: 4.month.ago)
      @article_2_four_months_ago = create(:article, published_at: 4.month.ago)

      @article_two_year_ago = create(:article, published_at: 2.year.ago)
      @article_2_two_year_ago = create(:article, published_at: 2.year.ago)
    end

    it 'should return all content for the year if only year sent' do
      expect(Article.published_at_like(2.year.ago.strftime('%Y')).map(&:id).sort).to eq([@article_two_year_ago.id, @article_2_two_year_ago.id].sort)
    end

    it 'should return all content for the month if year and month sent' do
      expect(Article.published_at_like(4.month.ago.strftime('%Y-%m')).map(&:id).sort).to eq([@article_four_months_ago.id, @article_2_four_months_ago.id].sort)
    end

    it 'should return all content on this date if date send' do
      expect(Article.published_at_like(2.month.ago.strftime('%Y-%m-%d')).map(&:id).sort).to eq([@article_two_month_ago.id].sort)
    end
  end

  describe '#has_child?' do
    it 'should be true if article has one to link it by parent_id' do
      parent = create(:article)
      create(:article, parent_id: parent.id)
      expect(parent).to be_has_child
    end
    it 'should be false if article has no article to link it by parent_id' do
      parent = create(:article)
      create(:article, parent_id: nil)
      expect(parent).not_to be_has_child
    end
  end

  describe 'self#last_draft(id)' do
    it 'should return article if no draft associated' do
      draft = create(:article, state: 'draft')
      expect(Article.last_draft(draft.id)).to eq(draft)
    end
    it 'should return draft associated to this article if there are one' do
      parent = create(:article)
      draft = create(:article, parent_id: parent.id, state: 'draft')
      expect(Article.last_draft(draft.id)).to eq(draft)
    end
  end

  describe 'an article published just before midnight UTC' do
    before do
      @timezone = Time.zone
      Time.zone = 'UTC'
      @a = build(:article)
      @a.published_at = '21 Feb 2011 23:30 UTC'
    end

    after do
      Time.zone = @timezone
    end

    describe '#permalink_url' do
      it 'uses UTC to determine correct day' do
        expect(@a.permalink_url).to eq('http://myblog.net/2011/02/21/a-big-article')
      end
    end

    describe '#find_by_permalink' do
      it 'uses UTC to determine correct day' do
        @a.save
        a = Article.find_by_permalink year: 2011, month: 2, day: 21, permalink: 'a-big-article'
        expect(a).to eq(@a)
      end
    end
  end

  describe 'an article published just after midnight UTC' do
    before do
      @timezone = Time.zone
      Time.zone = 'UTC'
      @a = build(:article)
      @a.published_at = '22 Feb 2011 00:30 UTC'
    end

    after do
      Time.zone = @timezone
    end

    describe '#permalink_url' do
      it 'uses UTC to determine correct day' do
        expect(@a.permalink_url).to eq('http://myblog.net/2011/02/22/a-big-article')
      end
    end

    describe '#find_by_permalink' do
      it 'uses UTC to determine correct day' do
        @a.save
        a = Article.find_by_permalink year: 2011, month: 2, day: 22, permalink: 'a-big-article'
        expect(a).to eq(@a)
      end
    end
  end

  describe 'an article published just before midnight JST (+0900)' do
    before do
      @time_zone = Time.zone
      Time.zone = 'Tokyo'
      @a = build(:article)
      @a.published_at = '31 Dec 2012 23:30 +0900'
    end

    after do
      Time.zone = @time_zone
    end

    describe '#permalink_url' do
      it 'uses JST to determine correct day' do
        expect(@a.permalink_url).to eq('http://myblog.net/2012/12/31/a-big-article')
      end
    end

    describe '#find_by_permalink' do
      it 'uses JST to determine correct day' do
        @a.save
        a = Article.find_by_permalink year: 2012, month: 12, day: 31, permalink: 'a-big-article'
        expect(a).to eq(@a)
      end
    end
  end

  describe 'an article published just after midnight  JST (+0900)' do
    before do
      @time_zone = Time.zone
      Time.zone = 'Tokyo'
      @a = build(:article)
      @a.published_at = '1 Jan 2013 00:30 +0900'
    end

    after do
      Time.zone = @time_zone
    end

    describe '#permalink_url' do
      it 'uses JST to determine correct day' do
        expect(@a.permalink_url).to eq('http://myblog.net/2013/01/01/a-big-article')
      end
    end

    describe '#find_by_permalink' do
      it 'uses JST to determine correct day' do
        @a.save
        a = Article.find_by_permalink year: 2013, month: 1, day: 1, permalink: 'a-big-article'
        expect(a).to eq(@a)
      end
    end
  end

  describe '#published_comments' do
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

  describe 'save_attachments!' do
    it 'calls save_attachment for each file given' do
      first_file = OpenStruct.new
      second_file = OpenStruct.new
      hash = { a_key: first_file, a_second_key: second_file }
      article = build(:article)
      expect(article).to receive(:save_attachment!).with(first_file)
      expect(article).to receive(:save_attachment!).with(second_file)
      article.save_attachments!(hash)
    end

    it 'do nothing with nil given' do
      article = build(:article)
      article.save_attachments!(nil)
    end
  end

  describe 'save_attachment!' do
    it 'calls resource create_and_upload and add this new resource' do
      resource = build(:resource)
      file = OpenStruct.new
      article = create(:article)
      expect(Resource).to receive(:create_and_upload).with(file).and_return(resource)
      article.save_attachment!(file).reload
      expect(article.resources).to eq [resource]
    end
  end

  describe '.really_send_pings' do
    context 'given a new article' do
      let(:article) { Article.new }

      it 'return nil and do nothing when blog should not send_outbound_pings' do
        expect_any_instance_of(Blog).to receive(:send_outbound_pings).and_return(false)
        expect(article.really_send_pings).to be_nil
      end

      context 'given a blog that allow send outbound pings' do
        before(:each) do
          expect_any_instance_of(Blog).to receive(:send_outbound_pings).and_return(true)
        end

        it 'do nothing when no urls to ping article' do
          expect_any_instance_of(Blog).to receive(:urls_to_ping_for).and_return([])
          expect(article).to receive(:html_urls_to_ping).and_return([])
          expect_any_instance_of(Ping).not_to receive(:send_weblogupdatesping)
          expect_any_instance_of(Ping).not_to receive(:send_pingback_or_trackback)
          article.really_send_pings
        end

        it 'do nothing when urls already list in article.pings (already ping ?)'  do
          ping = OpenStruct.new(url: 'an_url_to_ping')
          expect_any_instance_of(Blog).to receive(:urls_to_ping_for).and_return([ping])
          expect(article).to receive(:html_urls_to_ping).and_return(['an_url_to_ping'])
          expect_any_instance_of(Ping).not_to receive(:send_weblogupdatesping)
          expect_any_instance_of(Ping).not_to receive(:send_pingback_or_trackback)
          article.really_send_pings
        end

        it "calls send_weblogupdatesping when it's not already done"  do
          new_ping = OpenStruct.new
          urls_to_ping = [new_ping]
          expect_any_instance_of(Blog).to receive(:urls_to_ping_for).and_return(urls_to_ping)
          expect(article).to receive(:permalink_url)
          expect(article).to receive(:html_urls_to_ping).and_return([])
          expect(new_ping).to receive(:send_weblogupdatesping)
          expect(new_ping).not_to receive(:send_pingback_or_trackback)
          article.really_send_pings
        end

        it "calls send_pingback_or_trackback when it's not already done"  do
          expect_any_instance_of(Blog).to receive(:urls_to_ping_for).and_return([])
          new_ping = OpenStruct.new
          expect(article).to receive(:html_urls_to_ping).and_return([new_ping])
          expect(article).to receive(:permalink_url)
          expect(new_ping).to receive(:send_pingback_or_trackback)
          expect(new_ping).not_to receive(:send_weblogupdatesping)
          article.really_send_pings
        end
      end
    end
  end

  describe '#search_with' do
    subject { Article.search_with(params) }

    context 'without article' do
      let(:params) { nil }
      it { expect(subject).to be_empty }
    end

    context 'with an article' do
      let(:params) { nil }
      let!(:article) { create(:article) }
      it { expect(subject).to eq([article]) }
    end

    context 'with two article but only one matching searchstring' do
      let(:params) { { searchstring: 'match the string' } }
      let!(:not_found_article) { create(:article) }
      let!(:article) { create(:article, body: 'this match the string of article') }
      it { expect(subject).to eq([article]) }
    end

    context 'with two articles with differents states and published params' do
      let(:params) { { state: 'published' } }
      let!(:article) { create(:article, state: 'published') }
      let!(:draft_article) { create(:article, state: 'draft') }
      it { expect(subject).to eq([article]) }
    end

    context 'with two articles with differents states and no params' do
      let(:params) { nil }
      let(:now) { DateTime.new(2011, 3, 12) }
      let!(:article) { create(:article, state: 'published', created_at: now) }
      let!(:last_draft_article) { create(:article, state: 'draft', created_at: now + 2.days) }
      let!(:draft_article) { create(:article, state: 'draft', created_at: now + 20.days) }
      it { expect(subject).to eq([draft_article, last_draft_article, article]) }
    end
  end

  describe '.allow_comments?' do
    it 'true if article set to true' do
      expect(Article.new(allow_comments: true).allow_comments?).to be_truthy
    end

    it 'false if article set to false' do
      expect(Article.new(allow_comments: false).allow_comments?).to be_falsey
    end

    context 'given an article with no allow comments state' do
      it 'returns true when blog default allow comments is true' do
        expect_any_instance_of(Blog).to receive(:default_allow_comments).and_return(true)
        expect(Article.new(allow_comments: nil).allow_comments?).to be_truthy
      end

      it 'returns false when blog default allow comments is true' do
        expect_any_instance_of(Blog).to receive(:default_allow_comments).and_return(false)
        expect(Article.new(allow_comments: nil).allow_comments?).to be_falsey
      end
    end
  end

  describe '.allow_pings?' do
    it 'true if article set to true' do
      expect(Article.new(allow_pings: true).allow_pings?).to be_truthy
    end

    it 'false if article set to false' do
      expect(Article.new(allow_pings: false).allow_pings?).to be_falsey
    end

    context 'given an article with no allow pings state' do
      it 'returns true when blog default allow pings is true' do
        expect_any_instance_of(Blog).to receive(:default_allow_pings).and_return(true)
        expect(Article.new(allow_pings: nil).allow_pings?).to be_truthy
      end

      it 'returns false when blog default allow pings is true' do
        expect_any_instance_of(Blog).to receive(:default_allow_pings).and_return(false)
        expect(Article.new(allow_pings: nil).allow_pings?).to be_falsey
      end
    end
  end

  describe '#find_by_published_at' do
    it 'returns an empty array when no articles' do
      expect(Article.find_by_published_at).to be_empty
    end

    context 'returns objects that respond to publication with YYYY-MM published_at date format' do
      it 'with article published_at date' do
        create(:article, published_at: Date.new(2010, 11, 23))
        result = Article.find_by_published_at
        expect(result.count).to eq 1
        expect(result.first).to eq ['2010-11']
      end

      it 'with 2 articles' do
        create(:article, published_at: Date.new(2010, 11, 23))
        create(:article, published_at: Date.new(2002, 4, 9))
        result = Article.find_by_published_at
        expect(result.count).to eq 2
        expect(result.sort).to eq [['2010-11'], ['2002-04']].sort
      end
    end
  end

  describe 'published_since' do
    let(:time) { DateTime.new(2010, 11, 3, 23, 34) }
    it 'empty when no articles' do
      expect(Article.published_since(time)).to be_empty
    end

    it 'returns article that was published since' do
      article = create(:article, published_at: time + 2.hours)
      expect(Article.published_since(time)).to eq [article]
    end

    it 'returns only article that was published since last visit' do
      create(:article, published_at: time - 2.hours)
      article = create(:article, published_at: time + 2.hours)
      expect(Article.published_since(time)).to eq [article]
    end
  end

  describe 'bestof' do
    it 'returns empty array when no content' do
      expect(Article.bestof).to be_empty
    end

    it 'returns article with comment count field' do
      create(:comment)
      expect(Article.bestof.first.comment_count.to_i).to eq 1
    end

    it 'counts comments but not trackbacks' do
      article = create :article
      create :trackback, article: article
      create_list :comment, 2, article: article

      expect(Article.bestof.first.comment_count.to_i).to eq 2
    end

    it 'returns only 5 articles' do
      6.times { create(:comment) }
      expect(Article.bestof.length).to eq(5)
    end

    it 'returns only published articles' do
      article = create(:article)
      create(:comment, article: article)
      unpublished_article = create(:article, published: false, state: 'draft')
      create(:comment, article: unpublished_article)
      expect(Article.published).to eq([article])
      expect(Article.bestof).to eq([article])
    end

    it 'returns article sorted by comment counts' do
      last_article = create(:article)
      create(:comment, article: last_article)

      first_article = create(:article)
      create(:comment, article: first_article)
      create(:comment, article: first_article)

      expect(Article.bestof).to eq([first_article, last_article])
    end
  end

  describe 'update tags from article keywords' do
    before(:each) { article.save }

    context 'without keywords' do
      let(:article) { build(:article, keywords: nil) }
      it { expect(article.tags).to be_empty }
    end

    context 'with a simple keyword' do
      let(:article) { build(:article, keywords: 'foo') }
      it { expect(article.tags.size).to eq(1) }
      it { expect(article.tags.first).to be_kind_of(Tag) }
      it { expect(article.tags.first.name).to eq('foo') }
    end

    context 'with two keyword separate by a space' do
      let(:article) { build(:article, keywords: 'foo bar') }
      it { expect(article.tags.size).to eq(2) }
      it { expect(article.tags.map(&:name)).to eq(%w(foo bar)) }
    end

    context 'with two keyword separate by a coma' do
      let(:article) { build(:article, keywords: 'foo, bar') }
      it { expect(article.tags.size).to eq(2) }
      it { expect(article.tags.map(&:name)).to eq(%w(foo bar)) }
    end

    context 'with two keyword with apostrophe' do
      let(:article) { build(:article, keywords: "foo, l'bar") }
      it { expect(article.tags.size).to eq(3) }
      it { expect(article.tags.map(&:name)).to eq(%w(foo l bar)) }
    end

    context 'with two identical keywords' do
      let(:article) { build(:article, keywords: 'same, same') }
      it { expect(article.tags.size).to eq(1) }
      it { expect(article.tags.map(&:name)).to eq(['same']) }
    end

    context 'with keywords with dot and quote' do
      let(:article) { build(:article, keywords: 'foo "bar quiz" web2.0') }
      it { expect(article.tags.map(&:name)).to eq(['foo', 'bar-quiz', 'web2-0']) }
    end
  end

  describe '#post_type' do
    context 'without post_type' do
      let(:article) { build(:article, post_type: '') }
      it { expect(article.post_type).to eq('read') }
    end

    context 'with a oldschool read post_type' do
      let(:article) { build(:article, post_type: 'read') }
      it { expect(article.post_type).to eq('read') }
    end

    context 'with a specific myletter post_type' do
      let(:article) { build(:article, post_type: 'myletter') }
      it { expect(article.post_type).to eq('myletter') }
    end
  end
end
