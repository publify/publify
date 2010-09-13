require File.dirname(__FILE__) + '/../../spec_helper'

shared_examples_for "CommentSanitization" do
  before do
    @article = mock_model(Article, :created_at => Time.now, :published_at => Time.now)
    Article.stub!(:find).and_return(@article)
    this_blog.use_gravatar = false
    this_blog.lang = 'en_US'

    prepare_comment

    @comment.stub!(:id).and_return(1)
    assign(:comment, @comment)
  end

  def prepare_comment
    Comment.with_options(:body => 'test foo <script>do_evil();</script>',
                         :author => 'Bob', :article => @article,
                         :created_at => Time.now) do |klass|
      @comment = klass.new(comment_options)
    end
  end

  ['', 'markdown', 'textile', 'smartypants', 'markdown smartypants'].each do |value|
    it "Should sanitize content rendered with the #{value} textfilter" do
      this_blog.comment_text_filter = value

      render :file => 'comments/show'
      response.should have_selector('.content')
      response.should have_selector('.author')

      response.should_not have_selector('.content script')
      response.should_not have_selector(".content a:not([rel=nofollow])")
      # No links with javascript
      response.should_not have_selector(".content a[onclick]")
      response.should_not have_selector(".content a[href^=\"javascript:\"]")

      response.should_not have_selector('.author script')
      response.should_not have_selector(".author a:not([rel=nofollow])")
      # No links with javascript
      response.should_not have_selector(".author a[onclick]")
      response.should_not have_selector(".author a[href^=\"javascript:\"]")
    end
  end
end

describe "First dodgy comment" do
  it_should_behave_like "CommentSanitization"

  def comment_options
    { :body => 'test foo <script>do_evil();</script>' }
  end
end

describe "Second dodgy comment" do
  it_should_behave_like "CommentSanitization"

  def comment_options
    { :body => 'link to [spammy goodness](http://spammer.example.com)'}
  end
end

describe "Dodgy comment #3" do
  it_should_behave_like "CommentSanitization"

  def comment_options
    { :body => 'link to <a href="spammer.com">spammy goodness</a>'}
  end
end

describe "Extra Dodgy comment" do
  it_should_behave_like "CommentSanitization"

  def comment_options
    { :body => '<a href="http://spam.org">spam</a>',
      :author => '<a href="http://spamme.com>spamme</a>',
      :email => '<a href="http://itsallspam.com/">its all spam</a>' }
  end
end

describe "XSS1" do
  it_should_behave_like "CommentSanitization"

  def comment_options
    { :body => %{Have you ever <script lang="javascript">alert("foo");</script> been hacked?} }
  end
end

describe "XSS2" do
  it_should_behave_like "CommentSanitization"
  def comment_options
    { :body => %{<a href="#" onclick="javascript">bad link</a>}}
  end
end

describe "XSS2" do
  it_should_behave_like "CommentSanitization"

  def comment_options
    { :body => %{<a href="javascript:bad">bad link</a>}}
  end
end

describe "Comment with bare http URL" do
  it_should_behave_like "CommentSanitization"

  def comment_options
    { :body => %{http://www.example.com} }
  end
end

describe "Comment with bare email address" do
  it_should_behave_like "CommentSanitization"

  def comment_options
    { :body => %{foo@example.com} }
  end
end
