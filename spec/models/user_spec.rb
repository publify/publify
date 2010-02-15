require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  describe 'Factory Girl' do
    it 'should user factory valid' do
      Factory.create(:user).should be_valid
      Factory.build(:user).should be_valid
    end
    it 'should multiple user factory valid' do
      Factory.create(:user).should be_valid
      Factory.create(:user).should be_valid
    end
  end
end

describe 'With the contents and users fixtures loaded' do
  before(:each) do
    User.stub!(:salt).and_return('change-me')
  end

  it 'Calling User.authenticate with a valid user/password combo returns a user' do
    User.authenticate('bob', 'test').should == users(:bob)
  end

  it 'User.authenticate(user,invalid) returns nil' do
    User.authenticate('bob', 'wrong password').should be_nil
  end

  it 'User.authenticate(inactive,valid) returns nil' do
    User.authenticate('inactive', 'longtest').should be_nil
  end

  it 'User.authenticate(invalid,whatever) returns nil' do
    User.authenticate('userwhodoesnotexist', 'what ever').should be_nil
  end

  it 'The various article finders work appropriately' do
    users(:tobi).articles.size.should == 8
#    User.find(1).articles.find_published.size.should == Article.find(:all, :conditions => {:published => true}).size
    users(:tobi).articles.published.size.should == 7
  end

  it 'authenticate? works as expected' do
    User.should be_authenticate('bob', 'test')
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
        @user.errors.should be_invalid('password')
      end
    end

    it "has to match confirmation" do
      @user.password = "foo"
      @user.password_confirmation = "bar"
      @user.should_not be_valid
      @user.errors.should be_invalid('password')
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
        @user.errors.should be_invalid('login')
      end
    end
  end

  it 'email cannot be blank' do
    @user.email = ''
    @user.should_not be_valid
  end

  def set_password(newpass)
    @user.password = @user.password_confirmation = newpass
  end
end

describe 'With a user in the database' do
  before(:each) do
    @olduser = Factory.create(:user)
  end

  it 'should not be able to create another user with the same login' do
    login = @olduser.login
    u = User.new(:login => login) {|u| u.password = u.password_confirmation = 'secure password'}

    u.should_not be_valid
    u.errors.should be_invalid('login')
  end
end

describe 'Updating an existing user' do
  before(:each) do
    @user = Factory.create(:user)
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
        @user.errors.should be_invalid('password')
      end
    end

    it "has to match confirmation" do
      @user.password = "foo"
      @user.password_confirmation = "bar"
      @user.should_not be_valid
      @user.errors.should be_invalid('password')
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

describe User do
  describe '#admin?' do

    it 'should return true if user is admin' do
      users(:tobi).should be_admin
    end

    it 'should return false if user is not admin' do
      users(:user_publisher).should_not be_admin
    end

  end
end
