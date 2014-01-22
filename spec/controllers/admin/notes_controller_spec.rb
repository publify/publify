require 'spec_helper'

describe Admin::NotesController do
  render_views

  describe "For index action" do
    before :each do
      create(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      henri = create(:user, :login => 'henri', :profile => create(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => henri.id }
    end

    it 'should redirect to new' do
      get 'index'
      response.should redirect_to(:action => 'new')
    end

  end

  describe "For a new note" do
    before :each do
      create(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      henri = create(:user, :login => 'henri', :profile => create(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => henri.id }
    end

    it 'should render template new' do
      get 'new'
      response.should render_template('new')
    end
  end

  describe "Editing an existing note" do
    before :each do
      create(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      henri = create(:user, :login => 'henri', :profile => create(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => henri.id }
      @note = FactoryGirl.create(:note)
    end

    it 'should render template edit' do
      get 'edit', :id => @note.id
      response.should render_template('new')
    end
  end

  describe :new do
    describe "Creating a new note" do
      let!(:blog) { create(:blog) }
      let(:henri) { create(:user, :login => 'henri', :profile => create(:profile_admin, :label => Profile::ADMIN)) }

      before(:each) { request.session = { :user => henri.id } }

      context "without permalink" do
        before(:each) { post :new, note: { body: "Emphasis _mine_, arguments *strong*" } }

        it {expect(response).to redirect_to(controller: 'notes', action: 'new')}
        it {expect(Note.count).to eq(1) }
        it {expect(Note.first.body).to eq("Emphasis _mine_, arguments *strong*") }
        it {expect(session[:gflash][:notice]).to eq(["Note was successfully created"]) }
      end

      context "with permalink" do
        before(:each) { post :new, note: { body: "Emphasis _mine_, arguments *strong*", permalink: 'my-cool-permalink'} }

        it { expect(Note.last.permalink).to eq("my-cool-permalink") }
      end

      context "with an existing note" do
        let!(:existing_note) { create(:note) }
        before(:each) { post :new, note: { body: "Emphasis _mine_, arguments *strong*" } }

        it {expect(response).to redirect_to(controller: 'notes', action: 'new')}
        it {expect(Note.count).to eq(2) }
      end

      context "With missing params" do
        before :each do
          Note.delete_all
          post :new, note: { }
        end

        it {expect(response).to render_template(controller: 'notes', action: 'edit')}
        it {expect(Note.count).to eq(0) }
      end
    end
  end

  describe "Destorying a note" do
    before :each do
      create(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      henri = create(:user, :login => 'henri', :profile => create(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => henri.id }
      Note.delete_all
      @note = create(:note, :user_id => henri.id)
    end

    it 'should render template destroy' do
      get 'destroy', :id => @note.id
      response.should render_template('destroy')
      Note.count.should == 1
    end

    it 'should destroy the last existing note and return zero' do
      post 'destroy', :id => @note.id
      response.should redirect_to(:controller => 'admin/notes', :action => 'index')
      Note.count.should == 0
    end

  end

  describe :edit do
    context "when push to twitter" do
      it "call note to send to twitter" do
        create(:blog_with_twitter)
        henru = create(:user_admin, :with_twitter)

        request.session = { user: henru.id }
        expect(Note.count).to eq(0)

        twitter_cli = double(twitter_cli)
        Twitter::Client.should_receive(:new).and_return(twitter_cli)
        Tweet = Struct.new(:attrs)
        tweet = Tweet.new({id_str: '2344'})
        twitter_cli.should_receive(:update).and_return(tweet)

        post :new, note: { body: "Emphasis _mine_, arguments *strong*" }, push_to_twitter: "true"
        expect(Note.first.twitter_id).to eq('2344')
      end
    end
  end
end
