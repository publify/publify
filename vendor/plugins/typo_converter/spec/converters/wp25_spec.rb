require File.dirname(__FILE__) + '/../spec_helper'

# These are integration tests. They are not comprehensive. If you're
# hacking on the converter, please add tests first.

describe "WordPress 2.5 converter" do
  before :each do
    # Fixtures aren't being rolled back in the WP DB, so we delete them all before
    # each test. This is a simple hack, but slows things down.
    [
      WP25::Option, WP25::User, WP25::Post, WP25::Comment,
      WP25::Term, WP25::TermTaxonomy, WP25::TermRelationship
    ].each do |model_class|
      model_class.delete_all
    end

    Factory('WP25/option',
      :option_name => 'blogname', :option_value => 'My WordPress Blog')
    Factory('WP25/option',
      :option_name => 'blogdescription', :option_value => 'WordPress blog description')
  end

  it "runs without crashing" do
    run_converter
  end

  describe "given a user" do
    before :each do
      @poster = Factory('WP25/user',
        :display_name => 'A. User',
        :user_email => 'auser@notfound.com',
        :user_login => 'auser',
        :user_pass => 'not a valid password'
      )
    end

    it "creates a user" do
      lambda { run_converter }.should change(User, :count).by(1)
    end

    describe "and a post" do
      before :each do
        # TODO: figure out if we're handling GMT conversion correctly
        @post = Factory('WP25/post',
          :post_author => @poster.ID
        )
      end

      it "creates an article" do
        lambda { run_converter }.should change(Article, :count).by(1)
      end

      it "assigns the article's author" do
        run_converter
        @article = Article.find(:first, :order => 'created_at DESC')
        # NOTE: Article.author is from User.login; Comment.author is from User.name
        @article.author.should == @poster.user_login
        @article.user.login.should == @poster.user_login
      end

      describe "with an owned comment" do
        before :each do
          @commenter = Factory('WP25/user',
            :display_name => 'A. Commenter',
            :user_email => 'acommenter@notfound.com',
            :user_login => 'acommenter',
            :user_pass => 'not a valid password'
          )
          @comment = Factory('WP25/comment',
            :comment_post_ID => @post.ID,
            :user => @commenter
          )
        end

        it "creates a comment" do
          lambda { run_converter }.should change(Comment, :count).by(1)
        end

        it "assigns the comment's author" do
          run_converter
          @typo_comment = Comment.find(:first, :order => 'created_at DESC')
          # NOTE: Article.author is from User.login; Comment.author is from User.name
          @typo_comment.author.should == @commenter.display_name
          @typo_comment.user.login.should == @commenter.user_login
        end
      end

      describe "with an anonymous comment" do
        before :each do
          @comment = Factory('WP25/comment',
            :comment_post_ID => @post.ID,
            :comment_author => 'Anonymous Commenter'
          )
        end

        it "does not assign the comment's author" do
          run_converter
          @typo_comment = Comment.find(:first, :order => 'created_at DESC')
          @typo_comment.author.should == @comment.comment_author
          @typo_comment.user.should == nil
        end

        describe "that is spam" do
          before :each do
            @comment.update_attribute(:comment_approved, 'spam')
          end

          it "marks the created comment as spam" do
            run_converter
            @typo_comment = Comment.find(:first, :order => 'created_at DESC')
            @typo_comment.should be_spam
          end
        end
      end

      describe "with tags" do
        before :each do
          @tag = Factory('WP25/tag')
          @taxonomy = Factory('WP25/term_taxonomy',
            :term_id => @tag.term_id,
            :taxonomy => 'post_tag',
            :count => 1)
          @relationship = Factory('WP25/term_relationship',
            # TODO: use post association
            :object_id => @post.id,
            :term_taxonomy => @taxonomy)
        end

        it "applies the tags to the created post" do
          run_converter
          @article = Article.find(:first, :order => 'created_at DESC')
          @article.tags.count.should == 1
          @article.tags.first.name == @tag.name
        end
      end

      describe "with a category" do
        before :each do
          @category = Factory('WP25/category')
          @taxonomy = Factory('WP25/term_taxonomy',
            :term_id => @category.term_id,
            :taxonomy => 'category',
            :count => 1)
          @relationship = Factory('WP25/term_relationship',
            # TODO: use post association
            :object_id => @post.id,
            :term_taxonomy => @taxonomy)
        end

        it "places the created post in the category" do
          run_converter
          @article = Article.find(:first, :order => 'created_at DESC')
          @article.categories.count.should == 1
          @article.categories.first.name == @category.name
        end
      end
    end

    describe "and a page" do
      before :each do
        # TODO: figure out if we're handling GMT conversion correctly
        @page = Factory('WP25/page',
          :post_author => @poster.ID
        )
      end

      it "creates a page" do
        lambda { run_converter }.should change(Page, :count).by(1)
      end

      it "assigns the page's author" do
        run_converter
        @typo_page = Page.find(:first, :order => 'created_at DESC')
        # NOTE: Page.author is from User.login; Comment.author is from User.name
        @typo_page.author.should == @poster.user_login
        @typo_page.user.login.should == @poster.user_login
      end
    end
  end

  protected

  def run_converter(options = {})
    real_stdout = $stdout
    begin
      $stdout = StringIO.new unless options[:verbose]
      TypoPlugins.convert_from :wp25
    ensure
      $stdout = real_stdout
    end
  end
end
