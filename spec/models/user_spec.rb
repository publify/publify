require 'spec_helper'

describe User do
  describe 'FactoryGirl Girl' do

    it 'should user factory valid' do
      FactoryGirl.create(:user).should be_valid
      FactoryGirl.build(:user).should be_valid
    end

    it 'should multiple user factory valid' do
      FactoryGirl.create(:user).should be_valid
      FactoryGirl.create(:user).should be_valid
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
      alice = FactoryGirl.create(:user, :login => 'alice', :password => 'greatest')
      User.authenticate('alice', 'greatest').should == alice
    end

    it 'User.authenticate(user,invalid) returns nil' do
      FactoryGirl.create(:user, :login => 'alice', :password => 'greatest')
      User.authenticate('alice', 'wrong password').should be_nil
    end

    it 'User.authenticate(inactive,valid) returns nil' do
      FactoryGirl.create(:user, :login => 'alice', :state => 'inactive')
      User.authenticate('inactive', 'longtest').should be_nil
    end

    it 'User.authenticate(invalid,whatever) returns nil' do
      FactoryGirl.create(:user, :login => 'alice')
      User.authenticate('userwhodoesnotexist', 'what ever').should be_nil
    end

    it 'The various article finders work appropriately' do
      FactoryGirl.create(:blog)
      tobi = FactoryGirl.create(:user)
      7.times do
        FactoryGirl.create(:article, :user => tobi)
      end
      FactoryGirl.create(:article, :published => false, :published_at => nil, :user => tobi)
      tobi.articles.size.should == 8
      tobi.articles.published.size.should == 7
    end

    it 'authenticate? works as expected' do
      bob = FactoryGirl.create(:user, :login => 'bob', :password => 'testtest')
      User.should be_authenticate('bob', 'testtest')
      User.should_not be_authenticate('bob', 'duff password')
    end
  end

  describe 'With a new user' do
    before(:each) do
      @user = User.new :login => 'not_bob'
      @user.email = 'typo@typo.com'
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
      @olduser = FactoryGirl.create(:user)
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
      @user = FactoryGirl.create(:user)
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
      admin = FactoryGirl.build(:user, :profile => FactoryGirl.build(:profile_admin, :label => Profile::ADMIN))
      admin.should be_admin
    end

    it 'should return false if user is not admin' do
      publisher = FactoryGirl.build(:user, :profile => FactoryGirl.build(:profile_publisher))
      publisher.should_not be_admin
    end

  end

  describe '#permalink_url' do
    before(:each) { FactoryGirl.create(:blog, :base_url => 'http://myblog.net/') }
    subject { FactoryGirl.build(:user, :login => 'alice').permalink_url }
    it { should == 'http://myblog.net/author/alice' }
  end

  describe "#simple_editor?" do
    it "should be true if editor == 'simple'" do
      user = FactoryGirl.build(:user, :editor => 'simple')
      user.simple_editor?.should be_true
    end

    it "should be false if editor != 'simple'" do
      user = FactoryGirl.build(:user, :editor => 'visual')
      user.simple_editor?.should be_false
    end
  end

  describe "#visual_editor?" do
    it "should be true if editor == 'visual'" do
      user = FactoryGirl.build(:user, :editor => 'visual')
      user.visual_editor?.should be_true
    end

    it "should be false if editor != 'visual" do
      user = FactoryGirl.build(:user, :editor => 'simple')
      user.visual_editor?.should be_false
    end
  end

  describe "set_author" do
    it "uses user given param to set author AND user of article" do
      article = Article.new
      user = FactoryGirl.build(:user, login: 'Henri')
      article.set_author(user)
      article.author.should eq 'Henri'
      article.user.should eq user
    end
  end

  describe "generate_password!" do
    it "respond to generate_password!" do
      User.new.should respond_to(:generate_password!)
    end

    it "set a 7 char length password" do
      user = User.new
      user.should_receive(:rand).exactly(7).times.and_return(0)
      user.should_receive(:password=).with('a' * 7)
      user.generate_password!
    end
  end

  describe "default_text_filter" do
    it "returns none when editor set to visual" do
      user = FactoryGirl.build(:user, editor: "visual")
      expect(user.default_text_filter).to eq('none')
    end

    it "returns text_filter when editor set to simple" do
      blog = FactoryGirl.create(:blog)
      user = FactoryGirl.build(:user, editor: "simple")
      expect(user.default_text_filter.name).to eq(blog.text_filter)
    end
  end

end
