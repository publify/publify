# frozen_string_literal: true

require "rails_helper"
require "publify_core/testing_support/dns_mock"

RSpec.describe Trackback, type: :model do
  describe "validations" do
    let(:blog) { build_stubbed :blog }
    let(:trackback) { described_class.new }

    it "allows an article with open trackback window" do
      article = Article.new(blog: blog, allow_pings: true, state: "published",
                            published_at: 1.day.ago)

      expect(trackback).to allow_value(article).for(:article)
    end

    it "requires article trackback window to be open" do
      article = Article.new(blog: blog, allow_pings: true)

      expect(trackback).not_to allow_value(article).for(:article).
        with_message("Trackbacks are closed")
    end

    it "requires article to be open to trackback" do
      article = Article.new(blog: blog, allow_pings: false)

      expect(trackback).not_to allow_value(article).for(:article).
        with_message("Article is not open for trackbacks")
    end
  end

  describe "spam detection" do
    let(:article) { create(:article) }

    before do
      @blog = create(:blog)
      @blog.sp_global = true
      @blog.default_moderate_comments = false
      @blog.save!
    end

    it "Incomplete trackbacks should not be accepted" do
      tb = described_class.new(blog_name: "Blog name",
                               title: "Title",
                               excerpt: "Excerpt",
                               article_id: create(:article).id)
      expect(tb).not_to be_valid
      expect(tb.errors["url"]).to be_any
    end

    it "A valid trackback should be accepted" do
      tb = described_class.new(blog_name: "Blog name",
                               title: "Title",
                               url: "http://foo.com",
                               excerpt: "Excerpt",
                               article_id: create(:article).id)
      expect(tb).to be_valid
      tb.save
      expect(tb.guid.size).to be > 15
      expect(tb).not_to be_spam
    end

    it "Trackbacks with a spammy link in the excerpt should be rejected" do
      tb = article.trackbacks.
        build(ham_params.merge(excerpt: '<a href="http://chinaaircatering.com">spam</a>'))
      tb.classify_content
      expect(tb).to be_spammy
    end

    it "Trackbacks with a spammy source url should be rejected" do
      tb = article.trackbacks.build(ham_params.merge(url: "http://www.chinaircatering.com"))
      tb.classify_content
      expect(tb).to be_spammy
    end

    it "Trackbacks from a spammy ip address should be rejected" do
      tb = article.trackbacks.build(ham_params.merge(ip: "212.42.230.207"))
      tb.classify_content
      expect(tb).to be_spammy
    end

    def ham_params
      { blog_name: "Blog", title: "trackback", excerpt: "bland",
        url: "http://notaspammer.com", ip: "212.42.230.206" }
    end
  end
end
