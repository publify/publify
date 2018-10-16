# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'comments/_comment.html.erb', type: :view do
  shared_examples_for 'CommentSanitization' do
    let(:blog) { build_stubbed(:blog) }
    let(:article) { build_stubbed(:article, created_at: Time.zone.now, published_at: Time.zone.now, blog: blog) }
    let(:base_options) do
      {
        body: 'test foo <script>do_evil();</script>',
        author: 'Bob',
        article: article,
        created_at: Time.zone.now
      }
    end

    before do
      blog.plugin_avatar = ''
      blog.lang = 'en_US'

      @comment = Comment.new base_options.merge(comment_options)

      allow(@comment).to receive(:id).and_return(1)
      assign(:comment, @comment)
    end

    with_each_theme do |theme, _view_path|
      context "with theme #{theme}" do
        before do
          blog.theme = theme
        end

        ['', 'markdown', 'textile', 'smartypants', 'markdown smartypants'].each do |value|
          it "sanitizes content rendered with the #{value} textfilter" do
            blog.comment_text_filter = value
            create(value.empty? ? 'none' : value)

            render partial: 'comments/comment', locals: { comment: @comment }
            expect(rendered).to have_selector('.content')
            expect(rendered).to have_selector('.author')

            expect(rendered).not_to have_selector('.content script')
            expect(rendered).not_to have_selector('.content a:not([rel=nofollow])')
            # No links with javascript
            expect(rendered).not_to have_selector('.content a[onclick]')
            expect(rendered).not_to have_selector('.content a[href^="javascript:"]')

            expect(rendered).not_to have_selector('.author script')
            expect(rendered).not_to have_selector('.author a:not([rel=nofollow])')
            # No links with javascript
            expect(rendered).not_to have_selector('.author a[onclick]')
            expect(rendered).not_to have_selector('.author a[href^="javascript:"]')
          end
        end
      end
    end
  end

  describe 'First dodgy comment', type: :view do
    it_behaves_like 'CommentSanitization'

    def comment_options
      { body: 'test foo <script>do_evil();</script>' }
    end
  end

  describe 'Second dodgy comment', type: :view do
    it_behaves_like 'CommentSanitization'

    def comment_options
      { body: 'link to [spammy goodness](http://spammer.example.com)' }
    end
  end

  describe 'Dodgy comment #3', type: :view do
    it_behaves_like 'CommentSanitization'

    def comment_options
      { body: 'link to <a href="spammer.com">spammy goodness</a>' }
    end
  end

  describe 'Extra Dodgy comment', type: :view do
    it_behaves_like 'CommentSanitization'

    def comment_options
      { body: '<a href="http://spam.org">spam</a>',
        author: '<a href="http://spamme.com>spamme</a>',
        email: '<a href="http://itsallspam.com/">its all spam</a>' }
    end
  end

  describe 'XSS1', type: :view do
    it_behaves_like 'CommentSanitization'

    def comment_options
      { body: %{Have you ever <script lang="javascript">alert("foo");</script> been hacked?} }
    end
  end

  describe 'XSS2', type: :view do
    it_behaves_like 'CommentSanitization'
    def comment_options
      { body: %(<a href="#" onclick="javascript">bad link</a>) }
    end
  end

  describe 'XSS2', type: :view do
    it_behaves_like 'CommentSanitization'

    def comment_options
      { body: %(<a href="javascript:bad">bad link</a>) }
    end
  end

  describe 'Comment with bare http URL', type: :view do
    it_behaves_like 'CommentSanitization'

    def comment_options
      { body: %(http://www.example.com) }
    end
  end

  describe 'Comment with bare email address', type: :view do
    it_behaves_like 'CommentSanitization'

    def comment_options
      { body: %(foo@example.com) }
    end
  end

  shared_examples_for 'CommentSanitizationWithDofollow' do
    let(:blog) { create(:blog) }
    let(:article) { create(:article, created_at: Time.zone.now, published_at: Time.zone.now, blog: blog) }
    let(:base_options) do
      {
        body: 'test foo <script>do_evil();</script>',
        author: 'Bob',
        article: article,
        created_at: Time.zone.now
      }
    end

    before do
      blog.plugin_avatar = ''
      blog.lang = 'en_US'
      blog.dofollowify = true
      blog.save

      @comment = Comment.new base_options.merge(comment_options)

      allow(@comment).to receive(:id).and_return(1)
      assign(:comment, @comment)
    end

    with_each_theme do |theme, _view_path|
      context "with theme #{theme}" do
        before do
          blog.theme = theme
        end

        ['', 'markdown', 'textile', 'smartypants', 'markdown smartypants'].each do |value|
          it "sanitizes content rendered with the #{value} textfilter" do
            value == '' ? create(:none) : create(value)
            blog.comment_text_filter = value

            render partial: 'comments/comment', locals: { comment: @comment }
            expect(rendered).to have_selector('.content')
            expect(rendered).to have_selector('.author')

            expect(rendered).not_to have_selector('.content script')
            expect(rendered).not_to have_selector('.content a[rel=nofollow]')
            # No links with javascript
            expect(rendered).not_to have_selector('.content a[onclick]')
            expect(rendered).not_to have_selector('.content a[href^="javascript:"]')

            expect(rendered).not_to have_selector('.author script')
            expect(rendered).not_to have_selector('.author a[rel=nofollow]')
            # No links with javascript
            expect(rendered).not_to have_selector('.author a[onclick]')
            expect(rendered).not_to have_selector('.author a[href^="javascript:"]')
          end
        end
      end
    end
  end

  describe 'First dodgy comment with dofollow', type: :view do
    it_behaves_like 'CommentSanitizationWithDofollow'

    def comment_options
      { body: 'test foo <script>do_evil();</script>' }
    end
  end

  describe 'Second dodgy comment with dofollow', type: :view do
    it_behaves_like 'CommentSanitizationWithDofollow'

    def comment_options
      { body: 'link to [spammy goodness](http://spammer.example.com)' }
    end
  end

  describe 'Dodgy comment #3 with dofollow', type: :view do
    it_behaves_like 'CommentSanitizationWithDofollow'

    def comment_options
      { body: 'link to <a href="spammer.com">spammy goodness</a>' }
    end
  end

  describe 'Extra Dodgy comment with dofollow', type: :view do
    it_behaves_like 'CommentSanitizationWithDofollow'

    def comment_options
      { body: '<a href="http://spam.org">spam</a>',
        author: '<a href="http://spamme.com>spamme</a>',
        email: '<a href="http://itsallspam.com/">its all spam</a>' }
    end
  end

  describe 'XSS1 with dofollow', type: :view do
    it_behaves_like 'CommentSanitizationWithDofollow'

    def comment_options
      { body: %{Have you ever <script lang="javascript">alert("foo");</script> been hacked?} }
    end
  end

  describe 'XSS2 with dofollow', type: :view do
    it_behaves_like 'CommentSanitizationWithDofollow'
    def comment_options
      { body: %(<a href="#" onclick="javascript">bad link</a>) }
    end
  end

  describe 'XSS2 with dofollow', type: :view do
    it_behaves_like 'CommentSanitizationWithDofollow'

    def comment_options
      { body: %(<a href="javascript:bad">bad link</a>) }
    end
  end

  describe 'Comment with bare http URL with dofollow', type: :view do
    it_behaves_like 'CommentSanitizationWithDofollow'

    def comment_options
      { body: %(http://www.example.com) }
    end
  end

  describe 'Comment with bare email address with dofollow', type: :view do
    it_behaves_like 'CommentSanitizationWithDofollow'

    def comment_options
      { body: %(foo@example.com) }
    end
  end
end
