# frozen_string_literal: true

require "rails_helper"
require "timecop"

describe Article, type: :model do
  let(:blog) { create(:blog) }

  it "test_content_fields" do
    a = blog.articles.build
    assert_equal [:body, :extended], a.content_fields
  end

  describe "#permalink_url" do
    describe "with hostname" do
      let(:article) do
        blog.articles.build(permalink: "article-3",
                            published_at: Time.utc(2004, 6, 1))
      end

      it "includes the full blog url" do
        article.publish
        expect(article.permalink_url(nil, false)).
          to eq "#{blog.base_url}/2004/06/01/article-3"
      end
    end

    describe "without hostname" do
      let(:article) do
        blog.articles.build(permalink: "article-3",
                            published_at: Time.utc(2004, 6, 1))
      end

      it "includes just the blog root path" do
        article.publish
        expect(article.permalink_url(nil, true)).
          to eq "#{blog.root_path}/2004/06/01/article-3"
      end
    end

    # NOTE: URLs must not have any multibyte characters in them. The
    # browser may display them differently, though.
    describe "with a multibyte permalink" do
      let(:article) do
        blog.articles.build(permalink: "ルビー",
                            published_at: Time.utc(2004, 6, 1))
      end

      it "escapes the multibyte characters" do
        article.publish
        expect(article.permalink_url(nil, true)).
          to eq("#{blog.root_path}/2004/06/01/%E3%83%AB%E3%83%93%E3%83%BC")
      end
    end

    describe "with a permalink containing a space" do
      let(:article) do
        blog.articles.build(permalink: "hello there",
                            published_at: Time.utc(2004, 6, 1))
      end

      it "escapes the space as '%20', not as '+'" do
        article.publish
        expect(article.permalink_url(nil, true)).
          to eq("#{blog.root_path}/2004/06/01/hello%20there")
      end
    end

    describe "with a permalink containing a plus" do
      let(:article) do
        blog.articles.build(permalink: "one+two", published_at: Time.utc(2004,
                                                                         6, 1))
      end

      it "does not escape the plus" do
        article.publish
        expect(article.permalink_url(nil, true)).
          to eq("#{blog.root_path}/2004/06/01/one+two")
      end
    end

    it "returns nil when the article is not published" do
      article = blog.articles.build(permalink: "one+two")

      expect(article.permalink_url(nil, true)).to be_nil
    end
  end

  describe "#initialize" do
    it "accepts a settings field in its parameter hash" do
      blog.articles.build("password" => "foo")
    end
  end

  describe ".feed_url" do
    let(:article) do
      build(:article, permalink: "article-3", published_at: Time.utc(2004, 6,
                                                                     1))
    end

    it "returns url for atom feed for a Atom 1.0 asked" do
      expect(article.feed_url("atom10")).to eq "#{blog.base_url}/2004/06/01/article-3.atom"
    end

    it "returns url for rss feed for a RSS 2 asked" do
      expect(article.feed_url("rss20")).to eq "#{blog.base_url}/2004/06/01/article-3.rss"
    end
  end

  it "test_create" do
    a = blog.articles.build
    a.user_id = 1
    a.body = "Foo"
    a.title = "Zzz"
    assert a.save

    a.tags << Tag.find(create(:tag).id)
    assert_equal 1, a.tags.size

    b = described_class.find(a.id)
    assert_equal 1, b.tags.size
  end

  it "test_permalink_with_title" do
    article = create(:article, permalink: "article-3", published_at: Time.utc(2004, 6, 1))
    assert_equal(article, described_class.requested_article(year: 2004, month: 6, day: 1,
                                                            title: "article-3"))
    not_found = described_class.requested_article year: 2005, month: "06", day: "01",
                                                  title: "article-5"
    expect(not_found).to be_nil
  end

  it "test_strip_title" do
    assert_equal "article-3", "Article-3".to_url
    assert_equal "article-3", "Article 3!?#".to_url
    assert_equal "there-is-sex-in-my-violence", "There is Sex in my Violence!".to_url
    assert_equal "article", "-article-".to_url
    assert_equal "lorem-ipsum-dolor-sit-amet-consectetaur-adipisicing-elit",
                 "Lorem ipsum dolor sit amet, consectetaur adipisicing elit".to_url
    assert_equal "my-cats-best-friend", "My Cat's Best Friend".to_url
  end

  describe "#set_permalink" do
    it "works for simple cases" do
      a = blog.articles.build(title: "Article 3!", state: :published)
      a.set_permalink
      expect(a.permalink).to eq "article-3"
    end

    it "strips html" do
      a = blog.articles.build(title: "This <i>is</i> a <b>test</b>", state: :published)
      a.set_permalink
      assert_equal "this-is-a-test", a.permalink
    end

    it "does not escape multibyte characters" do
      a = blog.articles.build(title: "ルビー", state: :published)
      a.set_permalink
      expect(a.permalink).to eq("ルビー")
    end

    it "is called upon saving a published article" do
      a = blog.articles.build(title: "space separated")
      a.publish
      expect(a.permalink).to be_nil
      a.blog = create(:blog)
      a.save
      expect(a.permalink).to eq("space-separated")
    end

    it "does nothing for draft articles" do
      a = blog.articles.build(title: "space separated", state: :draft)
      a.set_permalink
      expect(a.permalink).to be_nil
    end
  end

  describe "the html_urls method" do
    let(:blog) { create :blog, text_filter: "none" }

    before do
      @article = blog.articles.build
    end

    it "extracts URLs from the generated body html" do
      @article.body = 'happy halloween <a href="http://www.example.com/public">with</a>'
      urls = @article.html_urls
      assert_equal ["http://www.example.com/public"], urls
    end

    it "onlies match the href attribute" do
      @article.body = '<a href="http://a/b">a</a> <a fhref="wrong">wrong</a>'
      urls = @article.html_urls
      assert_equal ["http://a/b"], urls
    end

    it "matches across newlines" do
      @article.body = "<a\nhref=\"http://foo/bar\">foo</a>"
      urls = @article.html_urls
      assert_equal ["http://foo/bar"], urls
    end

    it "matches with single quotes" do
      @article.body = "<a href='http://foo/bar'>foo</a>"
      urls = @article.html_urls
      assert_equal ["http://foo/bar"], urls
    end

    it "matches with no quotes" do
      @article.body = "<a href=http://foo/bar>foo</a>"
      urls = @article.html_urls
      assert_equal ["http://foo/bar"], urls
    end
  end

  describe "Testing redirects" do
    it "a new published article gets a redirect" do
      a = blog.articles.create!(title: "Some title", body: "some text")
      a.publish!
      expect(a.redirect).not_to be_nil
      expect(a.redirect.to_path).to eq(a.permalink_url)
    end

    it "a new unpublished article should not get a redirect" do
      a = blog.articles.create!(title: "Some title", body: "some text")
      expect(a.redirect).to be_nil
    end

    it "Changin a published article permalink url should only change the to redirection" do
      a = blog.articles.create!(title: "Some title", body: "some text")
      a.publish!
      expect(a.redirect).not_to be_nil
      expect(a.redirect.to_path).to eq(a.permalink_url)
      r = a.redirect.from_path

      a.permalink = "some-new-permalink"
      a.save
      expect(a.redirect).not_to be_nil
      expect(a.redirect.to_path).to eq(a.permalink_url)
      expect(a.redirect.from_path).to eq(r)
    end
  end

  it "test_find_published_by_tag_name" do
    art1 = create(:article)
    art2 = create(:article)
    create(:tag, name: "foo", contents: [art1, art2])
    articles = Tag.find_by(name: "foo").published_contents
    assert_equal 2, articles.size
  end

  it "test_future_publishing" do
    art = blog.articles.build(title: "title", body: "body",
                              published_at: 2.seconds.from_now)
    art.publish!

    expect(art).to be_publication_pending

    assert_equal 1, Trigger.count
    assert Trigger.where(pending_item_id: art.id).first
    assert !art.published?
    Timecop.freeze(4.seconds.from_now) do
      Trigger.fire
    end
    art.reload
    assert art.published?
  end

  it "test_triggers_are_dependent" do
    # TODO: Needs a fix for Rails ticket #5105: has_many: Dependent deleting
    # does not work with STI
    skip
    art = blog.articles.create!(title: "title", body: "body",
                                published_at: 1.hour.from_now)
    assert_equal 1, Trigger.count
    art.destroy
    assert_equal 0, Trigger.count
  end

  it "test_destroy_file_upload_associations" do
    a = create(:article)
    create(:resource, content: a)
    create(:resource, content: a)
    assert_equal 2, a.resources.size
    a.resources << create(:resource)
    assert_equal 3, a.resources.size
    a.destroy
    assert_equal 0, Resource.where(content_id: a.id).size
  end

  describe "#interested_users" do
    it "gathers users interested in new articles" do
      henri = create(:user, login: "henri", notify_on_new_articles: true)
      alice = create(:user, login: "alice", notify_on_new_articles: true)

      a = build(:article)
      users = a.interested_users
      expect(users).to match_array [alice, henri]
    end
  end

  it "test_withdrawal" do
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

  it "gets only ham not spam comment" do
    article = create(:article)
    ham_comment = create(:comment, article: article)
    create(:spam_comment, article: article)
    expect(article.comments.ham).to eq([ham_comment])
    expect(article.comments.count).to eq(2)
  end

  describe "#access_by?" do
    before do
      @alice = build(:user, :as_admin)
    end

    it "admin should have access to an article written by another" do
      expect(build(:article)).to be_access_by(@alice)
    end

    it "admin should have access to an article written by himself" do
      article = build(:article, author: @alice)
      expect(article).to be_access_by(@alice)
    end
  end

  describe "body_and_extended" do
    before do
      @article = blog.articles.build(
        body: "basic text",
        extended: "extended text to explain more and more how Publify is wonderful")
    end

    it "combines body and extended content" do
      expect(@article.body_and_extended).to eq(
        "#{@article.body}\n<!--more-->\n#{@article.extended}")
    end

    it "does not insert <!--more--> tags if extended is empty" do
      @article.extended = ""
      expect(@article.body_and_extended).to eq(@article.body)
    end
  end

  describe "#search" do
    describe "with one word and result" do
      it "has two items" do
        create(:article, extended: "extended talk")
        create(:article, extended: "Once uppon a time, an extended story")
        assert_equal 2, described_class.search("extended").size
      end
    end
  end

  describe "body_and_extended=" do
    before do
      @article = blog.articles.build
    end

    it "splits apart values at <!--more-->" do
      @article.body_and_extended = "foo<!--more-->bar"
      expect(@article.body).to eq("foo")
      expect(@article.extended).to eq("bar")
    end

    it "removes newlines around <!--more-->" do
      @article.body_and_extended = "foo\n<!--more-->\nbar"
      expect(@article.body).to eq("foo")
      expect(@article.extended).to eq("bar")
    end

    it "makes extended empty if no <!--more--> tag" do
      @article.body_and_extended = "foo"
      expect(@article.body).to eq("foo")
      expect(@article.extended).to be_empty
    end

    it "preserves extra <!--more--> tags" do
      @article.body_and_extended = "foo<!--more-->bar<!--more-->baz"
      expect(@article.body).to eq("foo")
      expect(@article.extended).to eq("bar<!--more-->baz")
    end

    it "is settable via self.attributes=" do
      @article.attributes = { body_and_extended: "foo<!--more-->bar" }
      expect(@article.body).to eq("foo")
      expect(@article.extended).to eq("bar")
    end
  end

  describe "#html" do
    let(:article) { build_stubbed :article }

    it "returns an html_safe string" do
      expect(article.html).to be_html_safe
    end
  end

  describe "#comment_url" do
    it "renders complete url of comment" do
      article = build_stubbed(:article, id: 123)
      expect(article.comment_url).
        to eq("#{blog.root_path}/comments?article_id=#{article.id}")
    end
  end

  describe "#preview_comment_url" do
    it "renders complete url of comment" do
      article = build_stubbed(:article, id: 123)
      expect(article.preview_comment_url).
        to eq("#{blog.root_path}/comments/preview?article_id=#{article.id}")
    end
  end

  it "test_can_ping_fresh_article_iff_it_allows_pings" do
    a = create(:article, allow_pings: true)
    assert_equal(false, a.pings_closed?)
    a.allow_pings = false
    assert_equal(true, a.pings_closed?)
  end

  it "test_cannot_ping_old_article" do
    a = create(:article, allow_pings: false)
    assert_equal(true, a.pings_closed?)
    a.allow_pings = false
    assert_equal(true, a.pings_closed?)
  end

  describe "#published_at_like" do
    before do
      # Note: these choices of times depend on no other articles within
      # these timeframes existing in test/fixtures/contents.yaml.
      # In particular, all articles there are from 2005 or earlier, which
      # is now more than two years ago, except for two, which are from
      # yesterday and the day before. The existence of those two makes
      # 1.month.ago not suitable, because yesterday can be last month.
      @article_two_month_ago = create(:article, published_at: 2.months.ago)

      @article_four_months_ago = create(:article, published_at: 4.months.ago)
      @article_2_four_months_ago = create(:article, published_at: 4.months.ago)

      @article_two_year_ago = create(:article, published_at: 2.years.ago)
      @article_2_two_year_ago = create(:article, published_at: 2.years.ago)
    end

    it "returns all content for the year if only year sent" do
      expect(described_class.published_at_like(2.years.ago.strftime("%Y")).map(&:id).sort).
        to eq([@article_two_year_ago.id, @article_2_two_year_ago.id].sort)
    end

    it "returns all content for the month if year and month sent" do
      result = described_class.published_at_like(4.months.ago.strftime("%Y-%m")).
        map(&:id).sort
      expect(result).
        to eq([@article_four_months_ago.id, @article_2_four_months_ago.id].sort)
    end

    it "returns all content on this date if date send" do
      result = described_class.published_at_like(2.months.ago.strftime("%Y-%m-%d")).
        map(&:id).sort
      expect(result).to eq([@article_two_month_ago.id].sort)
    end
  end

  describe "#has_child?" do
    it "is true if article has one to link it by parent_id" do
      parent = create(:article)
      create(:article, parent_id: parent.id)
      expect(parent).to be_has_child
    end

    it "is false if article has no article to link it by parent_id" do
      parent = create(:article)
      create(:article, parent_id: nil)
      expect(parent).not_to be_has_child
    end
  end

  describe "self#last_draft(id)" do
    it "returns article if no draft associated" do
      draft = create(:article, state: "draft")
      expect(described_class.last_draft(draft.id)).to eq(draft)
    end

    it "returns draft associated to this article if there are one" do
      parent = create(:article)
      draft = create(:article, parent_id: parent.id, state: "draft")
      expect(described_class.last_draft(draft.id)).to eq(draft)
    end
  end

  describe "an article published just before midnight UTC" do
    before do
      @timezone = Time.zone
      Time.zone = "UTC"
      @a = build(:article)
      @a.set_permalink
      @a.published_at = "21 Feb 2011 23:30 UTC"
    end

    after do
      Time.zone = @timezone
    end

    describe "#permalink_url" do
      it "uses UTC to determine correct day" do
        expect(@a.permalink_url).to eq "#{blog.base_url}/2011/02/21/a-big-article"
      end
    end

    describe "#requested_article" do
      it "uses UTC to determine correct day" do
        @a.save
        a = described_class.requested_article year: 2011, month: 2, day: 21,
                                              permalink: "a-big-article"
        expect(a).to eq(@a)
      end
    end
  end

  describe "an article published just after midnight UTC" do
    before do
      @timezone = Time.zone
      Time.zone = "UTC"
      @a = build(:article)
      @a.set_permalink
      @a.published_at = "22 Feb 2011 00:30 UTC"
    end

    after do
      Time.zone = @timezone
    end

    describe "#permalink_url" do
      it "uses UTC to determine correct day" do
        expect(@a.permalink_url).to eq "#{blog.base_url}/2011/02/22/a-big-article"
      end
    end

    describe "#requested_article" do
      it "uses UTC to determine correct day" do
        @a.save
        a = described_class.requested_article year: 2011, month: 2, day: 22,
                                              permalink: "a-big-article"
        expect(a).to eq(@a)
      end
    end
  end

  describe "an article published just before midnight JST (+0900)" do
    before do
      @time_zone = Time.zone
      Time.zone = "Tokyo"
      @a = build(:article)
      @a.set_permalink
      @a.published_at = "31 Dec 2012 23:30 +0900"
    end

    after do
      Time.zone = @time_zone
    end

    describe "#permalink_url" do
      it "uses JST to determine correct day" do
        expect(@a.permalink_url).to eq "#{blog.base_url}/2012/12/31/a-big-article"
      end
    end

    describe "#requested_article" do
      it "uses JST to determine correct day" do
        @a.save
        a = described_class.requested_article year: 2012, month: 12, day: 31,
                                              permalink: "a-big-article"
        expect(a).to eq(@a)
      end
    end
  end

  describe "an article published just after midnight  JST (+0900)" do
    before do
      @time_zone = Time.zone
      Time.zone = "Tokyo"
      @a = build(:article)
      @a.set_permalink
      @a.published_at = "1 Jan 2013 00:30 +0900"
    end

    after do
      Time.zone = @time_zone
    end

    describe "#permalink_url" do
      it "uses JST to determine correct day" do
        expect(@a.permalink_url).to eq("#{blog.base_url}/2013/01/01/a-big-article")
      end
    end

    describe "#requested_article" do
      it "uses JST to determine correct day" do
        @a.save
        a = described_class.requested_article year: 2013, month: 1, day: 1,
                                              permalink: "a-big-article"
        expect(a).to eq(@a)
      end
    end
  end

  describe "#published_comments" do
    let(:article) { create :article }

    it "does not include withdrawn comments" do
      comment = create :published_comment, article: article
      article.reload
      expect(article.published_comments).to eq [comment]
      comment.withdraw!
      article.reload
      expect(article.published_comments).to eq []
    end

    it "sorts comments newest last" do
      old_comment = create :published_comment, article: article, created_at: 2.days.ago
      new_comment = create :published_comment, article: article, created_at: 1.day.ago
      article.reload
      expect(article.published_comments).to eq [old_comment, new_comment]
    end
  end

  describe "#published_trackbacks" do
    let(:article) { create :article }

    it "does not include withdrawn trackbacks" do
      trackback = create :trackback, article: article
      article.reload
      expect(article.published_trackbacks).to eq [trackback]
      trackback.withdraw!
      article.reload
      expect(article.published_trackbacks).to eq []
    end

    it "sorts trackbacks newest last" do
      old_trackback = create :trackback, article: article, created_at: 2.days.ago
      new_trackback = create :trackback, article: article, created_at: 1.day.ago
      article.reload
      expect(article.published_trackbacks).to eq [old_trackback, new_trackback]
    end
  end

  describe "#published_feedback" do
    let(:article) { create :article }

    it "does not include withdrawn comments or trackbacks" do
      comment = create :published_comment, article: article
      trackback = create :trackback, article: article
      article.reload
      expect(article.published_feedback).to eq [comment, trackback]
      comment.withdraw!
      trackback.withdraw!
      article.reload
      expect(article.published_feedback).to eq []
    end

    it "sorts feedback newest last" do
      old_comment = create :published_comment, article: article, created_at: 4.days.ago
      old_trackback = create :trackback, article: article, created_at: 3.days.ago
      new_comment = create :published_comment, article: article, created_at: 2.days.ago
      new_trackback = create :trackback, article: article, created_at: 1.day.ago
      article.reload
      expect(article.published_feedback).
        to eq [old_comment, old_trackback, new_comment, new_trackback]
    end
  end

  describe "save_attachments!" do
    it "calls save_attachment for each file given" do
      first_file = OpenStruct.new
      second_file = OpenStruct.new
      hash = { a_key: first_file, a_second_key: second_file }
      article = build(:article)
      expect(article).to receive(:save_attachment!).with(first_file)
      expect(article).to receive(:save_attachment!).with(second_file)
      article.save_attachments!(hash)
    end

    it "do nothing with nil given" do
      article = build(:article)
      article.save_attachments!(nil)
    end
  end

  describe "save_attachment!" do
    let(:file) { file_upload("testfile.txt", "text/plain") }

    it "adds a new resource" do
      article = create(:article)
      article.save_attachment!(file)
      article.reload

      resource = article.resources.first
      upload = resource.upload

      expect(upload.file.basename).to eq "testfile"
    end
  end

  describe "#search_with" do
    subject { described_class.search_with(params) }

    context "without article" do
      let(:params) { nil }

      it { expect(subject).to be_empty }
    end

    context "with an article" do
      let(:params) { nil }
      let!(:article) { create(:article) }

      it { expect(subject).to eq([article]) }
    end

    context "with two article but only one matching searchstring" do
      let(:params) { { searchstring: "match the string" } }
      let!(:not_found_article) { create(:article) }
      let!(:article) { create(:article, body: "this match the string of article") }

      it { expect(subject).to eq([article]) }
    end

    context "with two articles with differents states and published params" do
      let(:params) { { state: "published" } }
      let!(:article) { create(:article, state: "published") }
      let!(:draft_article) { create(:article, state: "draft") }

      it { expect(subject).to eq([article]) }
    end

    context "with two articles with differents states and no params" do
      let(:params) { nil }
      let(:now) { DateTime.new(2011, 3, 12).in_time_zone }
      let!(:article) { create(:article, state: "published", created_at: now) }
      let!(:last_draft_article) do
        create(:article, state: "draft",
                         created_at: now + 2.days)
      end
      let!(:draft_article) { create(:article, state: "draft", created_at: now + 20.days) }

      it { expect(subject).to eq([draft_article, last_draft_article, article]) }
    end
  end

  describe ".allow_comments?" do
    it "true if article set to true" do
      expect(blog.articles.build(allow_comments: true)).to be_allow_comments
    end

    it "false if article set to false" do
      expect(blog.articles.build(allow_comments: false)).not_to be_allow_comments
    end

    context "given an article with no allow comments state" do
      it "returns true when blog default allow comments is true" do
        expect_any_instance_of(Blog).to receive(:default_allow_comments).and_return(true)
        expect(blog.articles.build(allow_comments: nil)).to be_allow_comments
      end

      it "returns false when blog default allow comments is true" do
        expect_any_instance_of(Blog).to receive(:default_allow_comments).and_return(false)
        expect(blog.articles.build(allow_comments: nil)).not_to be_allow_comments
      end
    end
  end

  describe ".allow_pings?" do
    it "true if article set to true" do
      expect(blog.articles.build(allow_pings: true)).to be_allow_pings
    end

    it "false if article set to false" do
      expect(blog.articles.build(allow_pings: false)).not_to be_allow_pings
    end

    context "given an article with no allow pings state" do
      it "returns true when blog default allow pings is true" do
        expect_any_instance_of(Blog).to receive(:default_allow_pings).and_return(true)
        expect(blog.articles.build(allow_pings: nil)).to be_allow_pings
      end

      it "returns false when blog default allow pings is true" do
        expect_any_instance_of(Blog).to receive(:default_allow_pings).and_return(false)
        expect(blog.articles.build(allow_pings: nil)).not_to be_allow_pings
      end
    end
  end

  describe "#publication_months" do
    it "returns an empty array when no articles" do
      expect(described_class.publication_months).to be_empty
    end

    it "returns months of publication for published articles" do
      create(:article, published_at: Date.new(2010, 11, 23))
      create(:article, published_at: Date.new(2002, 4, 9))
      result = described_class.publication_months
      expect(result).to match_array [["2010-11"], ["2002-04"]]
    end
  end

  describe "published_since" do
    let(:time) { DateTime.new(2010, 11, 3, 23, 34).in_time_zone }

    it "empty when no articles" do
      expect(described_class.published_since(time)).to be_empty
    end

    it "returns article that was published since" do
      article = create(:article, published_at: time + 2.hours)
      expect(described_class.published_since(time)).to eq [article]
    end

    it "returns only article that was published since last visit" do
      create(:article, published_at: time - 2.hours)
      article = create(:article, published_at: time + 2.hours)
      expect(described_class.published_since(time)).to eq [article]
    end
  end

  describe "bestof" do
    it "returns empty array when no content" do
      expect(described_class.bestof).to be_empty
    end

    it "returns article with comment count field" do
      create(:comment)
      expect(described_class.bestof.first.comment_count.to_i).to eq 1
    end

    it "counts comments but not trackbacks" do
      article = create :article
      create :trackback, article: article
      create_list :comment, 2, article: article

      expect(described_class.bestof.first.comment_count.to_i).to eq 2
    end

    it "returns only 5 articles" do
      create_list(:comment, 6)
      expect(described_class.bestof.length).to eq(5)
    end

    it "returns only published articles" do
      article = create(:article)
      create(:comment, article: article)
      unpublished_article = create(:article, state: "draft")
      create(:comment, article: unpublished_article)
      expect(described_class.published).to eq([article])
      expect(described_class.bestof).to eq([article])
    end

    it "returns article sorted by comment counts" do
      last_article = create(:article)
      create(:comment, article: last_article)

      first_article = create(:article)
      create(:comment, article: first_article)
      create(:comment, article: first_article)

      expect(described_class.bestof).to eq([first_article, last_article])
    end
  end

  describe "update tags from article keywords" do
    before { article.save }

    context "without keywords" do
      let(:article) { build(:article, keywords: nil) }

      it { expect(article.tags).to be_empty }
    end

    context "with a simple keyword" do
      let(:article) { build(:article, keywords: "foo") }

      it { expect(article.tags.size).to eq(1) }
      it { expect(article.tags.first).to be_kind_of(Tag) }
      it { expect(article.tags.first.name).to eq("foo") }
    end

    context "with two keyword separate by a space" do
      let(:article) { build(:article, keywords: "foo bar") }

      it { expect(article.tags.size).to eq(2) }
      it { expect(article.tags.map(&:name)).to eq(%w(foo bar)) }
    end

    context "with two keyword separate by a coma" do
      let(:article) { build(:article, keywords: "foo, bar") }

      it { expect(article.tags.size).to eq(2) }
      it { expect(article.tags.map(&:name)).to eq(%w(foo bar)) }
    end

    context "with two keyword with apostrophe" do
      let(:article) { build(:article, keywords: "foo, l'bar") }

      it { expect(article.tags.size).to eq(3) }
      it { expect(article.tags.map(&:name)).to eq(%w(foo l bar)) }
    end

    context "with two identical keywords" do
      let(:article) { build(:article, keywords: "same, same") }

      it { expect(article.tags.size).to eq(1) }
      it { expect(article.tags.map(&:name)).to eq(["same"]) }
    end

    context "with keywords with dot and quote" do
      let(:article) { build(:article, keywords: 'foo "bar quiz" web2.0') }

      it { expect(article.tags.map(&:name)).to eq(["foo", "bar-quiz", "web2-0"]) }
    end
  end

  describe "#post_type" do
    context "without post_type" do
      let(:article) { build(:article, post_type: "") }

      it { expect(article.post_type).to eq("read") }
    end

    context "with a oldschool read post_type" do
      let(:article) { build(:article, post_type: "read") }

      it { expect(article.post_type).to eq("read") }
    end

    context "with a specific myletter post_type" do
      let(:article) { build(:article, post_type: "myletter") }

      it { expect(article.post_type).to eq("myletter") }
    end
  end

  describe "#comments_closed?" do
    let!(:blog) do
      create(:blog, sp_article_auto_close: auto_close_value,
                    default_allow_comments: true)
    end

    context "when auto_close setting is zero" do
      let(:auto_close_value) { 0 }

      it "allows comments for a newly published article" do
        art = build :article, published_at: 1.second.ago, blog: blog
        assert !art.comments_closed?
      end

      it "allows comments for a very old article" do
        art = build :article, created_at: 1000.days.ago, blog: blog
        assert !art.comments_closed?
      end
    end

    context "when auto_close setting is nonzero" do
      let(:auto_close_value) { 30 }

      it "allows comments for a recently published article" do
        art = build :article, published_at: 29.days.ago, blog: blog
        assert !art.comments_closed?
      end

      it "does not allow comments for an old article" do
        art = build :article, published_at: 31.days.ago, blog: blog
        assert art.comments_closed?
      end
    end
  end
end
