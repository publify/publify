require 'spec_helper'

describe User do
  describe 'FactoryGirl Girl' do
    it 'should user factory valid' do
      create(:user).should be_valid
      build(:user).should be_valid
    end

    it 'should multiple user factory valid' do
      create(:user).should be_valid
      create(:user).should be_valid
    end

    it 'salt should not be nil' do
      User.salt.should == '20ac4d290c2293702c64b3b287ae5ea79b26a5c1'
    end
  end

  context 'With the contents and users fixtures loaded' do
    before(:each) do
      User.stub(:salt).and_return('change-me')
    end

    it 'Calling User.authenticate with a valid user/password combo returns a user' do
      alice = create(:user, :login => 'alice', :password => 'greatest')
      User.authenticate('alice', 'greatest').should == alice
    end

    it 'User.authenticate(user,invalid) returns nil' do
      create(:user, :login => 'alice', :password => 'greatest')
      User.authenticate('alice', 'wrong password').should be_nil
    end

    it 'User.authenticate(inactive,valid) returns nil' do
      create(:user, :login => 'alice', :state => 'inactive')
      User.authenticate('inactive', 'longtest').should be_nil
    end

    it 'User.authenticate(invalid,whatever) returns nil' do
      create(:user, :login => 'alice')
      User.authenticate('userwhodoesnotexist', 'what ever').should be_nil
    end

    it 'The various article finders work appropriately' do
      create(:blog)
      tobi = create(:user)
      7.times { create(:article, user: tobi) }
      create(:article, published: false, state: 'draft', published_at: nil, user: tobi)
      tobi.articles.size.should == 8
      tobi.articles.published.size.should == 7
    end

    it 'authenticate? works as expected' do
      bob = create(:user, :login => 'bob', :password => 'testtest')
      User.should be_authenticate('bob', 'testtest')
      User.should_not be_authenticate('bob', 'duff password')
    end
  end

  describe 'With a new user' do
    before(:each) do
      @user = User.new :login => 'not_bob'
      @user.email = 'publify@publify.com'
      set_password 'a secure password'
    end

    describe "the password" do
      it 'can be just right' do
        set_password 'Just right'
        @user.should be_valid
      end

      { 'too short' => 'x',
        'too long' => 'repetitivepass' * 10,
        'empty' => ''
      }.each do |problematic, password|
        it "cannot be #{problematic}" do
          set_password password
          @user.should_not be_valid
          @user.errors['password'].should be_any
        end
      end

      it "has to match confirmation" do
        @user.password = "foo"
        @user.password_confirmation = "bar"
        @user.should_not be_valid
        @user.errors['password'].should be_any
      end
    end

    describe 'the login' do
      it 'can be just right' do
        @user.login = 'okbob'
        @user.should be_valid
      end

      { 'too short' => 'x',
        'too long' => 'repetitivepass' * 10,
        'empty' => ''
      }.each do |problematic, login|
        it "cannot be #{problematic}" do
          @user.login = login
          @user.should_not be_valid
          @user.errors['login'].should be_any
        end
      end
    end

    it 'email cannot be blank' do
      @user.email = ''
      @user.should_not be_valid
    end

    describe "#display_name" do
      it 'should not be blank' do
        @user.display_name.should_not be_empty
      end
    end

    def set_password(newpass)
      @user.password = @user.password_confirmation = newpass
    end
  end

  describe 'With a user in the database' do
    before(:each) do
      @olduser = create(:user)
    end

    it 'should not be able to create another user with the same login' do
      login = @olduser.login
      u = User.new(:login => login) {|u| u.password = u.password_confirmation = 'secure password'}

      u.should_not be_valid
      u.errors['login'].should be_any
    end
  end

  describe 'Updating an existing user' do
    before(:each) do
      @user = create(:user)
      set_password 'a secure password'
      @user.save!
    end

    describe "the password" do
      { 'just right' => 'Just right',
        'empty' => ''
      }.each do |ok, password|
        it "can be #{ok}" do
          set_password password
          @user.should be_valid
        end
      end

      { 'too short' => 'x',
        'too long' => 'repetitivepass' * 10,
      }.each do |problematic, password|
        it "cannot be #{problematic}" do
          set_password password
          @user.should_not be_valid
          @user.errors['password'].should be_any
        end
      end

      it "has to match confirmation" do
        @user.password = "foo"
        @user.password_confirmation = "bar"
        @user.should_not be_valid
        @user.errors['password'].should be_any
      end

      it "is not actually changed when set to empty" do
        set_password ''
        @user.save!
        User.authenticate(@user.login, '').should be_nil
        User.authenticate(@user.login, 'a secure password').should == @user
      end
    end

    describe "saving twice" do
      it "should not change the password" do
        (found = User.authenticate(@user.login, 'a secure password')).should == @user
        found.save
        found.save
        User.authenticate(@user.login, 'a secure password').should == found
      end
    end

    describe 'the login' do
      it 'must not change' do
        @user.login = 'not_bob'
        @user.should_not be_valid
      end
    end

    def set_password(newpass)
      @user.password = @user.password_confirmation = newpass
    end
  end

  describe "#initialize" do
    it "accepts a settings field in its parameter hash" do
      User.new({"firstname" => 'foo'})
    end
  end

  describe '#admin?' do
    it 'should return true if user is admin' do
      admin = build(:user, :profile => build(:profile_admin, :label => Profile::ADMIN))
      admin.should be_admin
    end

    it 'should return false if user is not admin' do
      publisher = build(:user, :profile => build(:profile_publisher))
      publisher.should_not be_admin
    end
  end

  describe :generate_password! do
    it "set a 7 char length password" do
      user = User.new
      user.should_receive(:rand).exactly(7).times.and_return(0)
      user.should_receive(:password=).with('a' * 7)
      user.generate_password!
    end
  end

  describe "default_text_filter" do
    it "returns user text_filter" do
      blog = create(:blog)
      user = build(:user)
      expect(user.default_text_filter.name).to eq(blog.text_filter)
    end
  end

  describe :first_and_last_name do
    context "with first and last name" do
      let(:user) { create(:user, firstname: 'Marlon', lastname: 'Brando') }
      it { expect(user.first_and_last_name).to eq('Marlon Brando') }
    end

    context "with firstname without lastname" do
      let(:user) { create(:user, firstname: 'Marlon', lastname: nil) }
      it { expect(user.first_and_last_name).to eq('') }
    end
  end

  describe :display_names do
    context "with user without nickname, firstname, lastname" do
      let(:user) { create(:user, nickname: nil, firstname: nil, lastname: nil) }
      it { expect(user.display_names).to eq([user.login]) }
    end

    context "with user with nickname without firstname, lastname" do
      let(:user) { create(:user, nickname: 'Bob', firstname: nil, lastname: nil) }
      it { expect(user.display_names).to eq([user.login, user.nickname]) }
    end

    context "with user with firstname, without nickname, lastname" do
      let(:user) { create(:user, nickname: nil, firstname: 'Robert', lastname: nil) }
      it { expect(user.display_names).to eq([user.login, user.firstname]) }
    end

    context "with user with lastname, without nickname, firstname" do
      let(:user) { create(:user, nickname: nil, firstname: nil, lastname: 'Redford') }
      it { expect(user.display_names).to eq([user.login, user.lastname]) }
    end

    context "with user with firstname and lastname, witjout nickname" do
      let(:user) { create(:user, nickname: nil, firstname: 'Robert', lastname: 'Redford') }
      it { expect(user.display_names).to eq([user.login, user.firstname, user.lastname, "#{user.firstname} #{user.lastname}"]) }
    end
  end

  describe "User's Twitter configuration" do
    it "A user without twitter_oauth_token or twitter_oauth_token_secret should not have Twitter configured" do
      user = build(:user, twitter_oauth_token:nil, twitter_oauth_token_secret:nil)
      user.has_twitter_configured?.should == false
    end

    it "A user with an empty twitter_oauth_token and no twitter_oauth_token_secret should not have Twitter configured" do
      user = build(:user, twitter_oauth_token: "", twitter_oauth_token_secret: nil)
      user.has_twitter_configured?.should == false
    end

    it "A user with an empty twitter_oauth_token and an empty twitter_oauth_token_secret should not have Twitter configured" do
      user = build(:user, twitter_oauth_token: "", twitter_oauth_token_secret: "")
      user.has_twitter_configured?.should == false
    end

    it "A user with a twitter_oauth_token and no twitter_oauth_token_secret should not have Twitter configured" do
      user = build(:user, twitter_oauth_token: "12345", twitter_oauth_token_secret: '')
      user.has_twitter_configured?.should == false
    end

    it "A user with a twitter_oauth_token and an empty twitter_oauth_token_secret should not have Twitter configured" do
      user = build(:user, twitter_oauth_token: "12345", twitter_oauth_token_secret: "")
      user.has_twitter_configured?.should == false
    end

    it "A user with a twitter_oauth_token_secret and no twitter_oauth_token should not have Twitter configured" do
      user = build(:user, twitter_oauth_token: "", twitter_oauth_token_secret: "67890")
      user.has_twitter_configured?.should == false
    end

    it "A user with a twitter_oauth_token_secret and an empty twitter_oauth_token should not have Twitter configured" do
      user = build(:user, twitter_oauth_token_secret: "67890", twitter_oauth_token: "")
      user.has_twitter_configured?.should == false
    end

    it "A user with a twitter_oauth_token and a twitter_oauth_token_secret should have Twitter configured" do
      user = build(:user, twitter_oauth_token: "12345", twitter_oauth_token_secret: "67890")
      user.has_twitter_configured?.should == true
    end
  end

  describe :can_access_to do
    let(:profile) { create(:profile, modules: modules) }
    let(:user) { create(:user, profile: profile) }

    AccessControl.available_modules.each do |m|
      context "without module #{m}" do
        let(:modules) { [] }
        it { expect(user.send("can_access_to_#{m}?")).to be_false }
      end

      context "with module #{m}" do
        let(:modules) { [m] }
        it { expect(user.send("can_access_to_#{m}?")).to be_true }
      end
    end
  end
end
