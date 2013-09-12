require 'spec_helper'

describe AuthorsController do
  describe '#show' do
    let!(:blog) { FactoryGirl.create(:blog, :limit_article_display => 1) }
    let!(:no_profile_user) { FactoryGirl.create(:user_with_an_empty_profile) }
    let!(:article) { FactoryGirl.create(:article, :user => no_profile_user) }
    let!(:unpublished_article) { FactoryGirl.create(:unpublished_article, :user => no_profile_user) }
    let!(:full_profile_user) { FactoryGirl.create(:user_with_a_full_profile) }
    let!(:article2) { FactoryGirl.create(:article, :user => full_profile_user) }
    let!(:article3) { FactoryGirl.create(:article, :user => full_profile_user) }
    
    describe "With an empty profile" do
      describe "as html" do
        before do
          get 'show', :id => no_profile_user.login
        end

        it 'renders the :show template' do
          response.should render_template(:show)
        end

        it 'assigns author' do
          assigns(:author).should == no_profile_user
        end

        it 'assigns articles as published articles' do
          assigns(:articles).should == [article]
        end

        describe "when rendered" do
          render_views

          it 'has a link to the rss feed' do
            response.should have_selector("head>link[href=\"http://test.host/author/#{no_profile_user.login}.rss\"]")
          end

          it 'has a link to the atom feed' do
            response.should have_selector("head>link[href=\"http://test.host/author/#{no_profile_user.login}.atom\"]")
          end
        
          it 'includes an image to the user avatar when available' do
            response.should_not have_selector("img[alt=\"James Bond\"]")
          end
        
          it 'uncompleted profile should not show Web site' do
            response.should_not have_selector('li', :content => "Web site:")
          end

          it 'uncompleted profile should not show MSN account' do
            response.should_not have_selector('li', :content => "MSN:")
          end
        
          it 'uncompleted profile should not show Yahoo account' do
            response.should_not have_selector('li', :content => "Yahoo:")
          end
          
          it 'uncompleted profile should not show Jabber account' do
            response.should_not have_selector('li', :content => "Jabber:")
          end

          it 'uncompleted profile should not show AIM account' do
            response.should_not have_selector('li', :content => "AIM:")
          end

          it 'uncompleted profile should not show Twitter account' do
            response.should_not have_selector('li', :content => "AIM:")
          end

          it 'uncompleted profile should not show user description' do
            response.should_not have_selector('div', :id => "author-description")
          end
        end
      end # end of html
      
      describe "as an atom feed" do
        before do
          get 'show', :id => no_profile_user.login, :format => 'atom'
        end

        it 'assigns articles as published articles' do
          assigns(:articles).should == [article]
        end

        it "renders the atom template" do
          response.should be_success
          response.should render_template("show_atom_feed")
        end

        it "does not render layout" do
          @layouts.keys.compact.should be_empty
        end
      end # end of atom feed
      
      describe "as an rss feed" do
        before do
          get 'show', :id => no_profile_user.login, :format => 'rss'
        end

        it 'assigns articles as published articles' do
          assigns(:articles).should == [article]
        end

        it "renders the rss template" do
          response.should be_success
          response.should render_template("show_rss_feed")
        end

        it "does not render layout" do
          @layouts.keys.compact.should be_empty
        end
      end # end of rss feed
      
      describe "with pagination" do
        before do
          get 'show', :id => no_profile_user.login, :page => 2
        end
        
        it 'renders a 404' do
          response.should render_template(:show)
        end

        it 'assigns no articles' do
          assigns(:articles).should == []
        end        
      end
    end # end of empty profile

    describe "With full profile" do
      describe "as html" do
        before do
          get 'show', :id => full_profile_user.login
        end

        it 'renders the :show template' do
          response.should render_template(:show)
        end

        it 'assigns author' do
          assigns(:author).should == full_profile_user
        end

        it 'assigns articles as published articles' do
          assigns(:articles).should == [article3]
        end

        describe "when rendered" do
          render_views

          it 'has a link to the rss feed' do
            response.should have_selector("head>link[href=\"http://test.host/author/#{full_profile_user.login}.rss\"]")
          end

          it 'has a link to the atom feed' do
            response.should have_selector("head>link[href=\"http://test.host/author/#{full_profile_user.login}.atom\"]")
          end
        
          it 'includes an image to the user avatar when available' do
            response.should_not have_selector("img[alt=\"James Bond\"]")
          end
        
          it 'completed profile should not show Web site' do
            response.should have_selector('li', :content => "Web site:")
          end

          it 'completed profile should not show MSN account' do
            response.should have_selector('li', :content => "MSN:")
          end
        
          it 'completed profile should not show Yahoo account' do
            response.should have_selector('li', :content => "Yahoo:")
          end
          
          it 'completed profile should not show Jabber account' do
            response.should have_selector('li', :content => "Jabber:")
          end

          it 'completed profile should not show AIM account' do
            response.should have_selector('li', :content => "AIM:")
          end

          it 'completed profile should not show Twitter account' do
            response.should have_selector('li', :content => "AIM:")
          end

          it 'completed profile should not show user description' do
            response.should have_selector('div', :id => "author-description")
          end
        end
      end # end of html
      
      describe "as an atom feed" do
        before do
          get 'show', :id => full_profile_user.login, :format => 'atom'
        end

        it 'assigns articles as published articles' do
          assigns(:articles).should == [article3, article2]
        end

        it "renders the atom template" do
          response.should be_success
          response.should render_template("show_atom_feed")
        end

        it "does not render layout" do
          @layouts.keys.compact.should be_empty
        end
      end # end of atom feed
      
      describe "as an rss feed" do
        before do
          get 'show', :id => full_profile_user.login, :format => 'rss'
        end

        it 'assigns articles as published articles' do
          assigns(:articles).should == [article3, article2]
        end

        it "renders the rss template" do
          response.should be_success
          response.should render_template("show_rss_feed")
        end

        it "does not render layout" do
          @layouts.keys.compact.should be_empty
        end
      end # end of rss feed
      
      describe "with pagination" do
        before do
          get 'show', :id => full_profile_user.login, :page => 2
        end
        
        it 'renders a 404' do
          response.should render_template(:show)
        end

        it 'assigns 1 article' do
          assigns(:articles).should == [article2]
        end        
      end # end of pagination
    end # end of full profile
  end
end

describe AuthorsController, "SEO options" do
  render_views

  it 'should never have meta keywords with deactivated option' do
    FactoryGirl.create(:blog, :use_meta_keyword => false)
    FactoryGirl.create(:user, :login => 'henri')
    get 'show', :id => 'henri'
    response.should_not have_selector('head>meta[name="keywords"]')
  end

  it 'should never have meta keywords with deactivated option' do
    FactoryGirl.create(:blog, :use_meta_keyword => true)
    FactoryGirl.create(:user, :login => 'alice')
    get 'show', :id => 'alice'
    response.should_not have_selector('head>meta[name="keywords"]')
  end
end
