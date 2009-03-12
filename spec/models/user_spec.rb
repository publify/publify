require File.dirname(__FILE__) + '/../spec_helper'

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

  it 'password cannot be too short' do
    set_password 'tiny'
    @user.should_not be_valid
    @user.errors.should be_invalid('password')
  end

  it 'password cannot be too long' do
    set_password 'x' * 80
    @user.should_not be_valid
    @user.errors.should be_invalid('password')
  end

  it 'password cannot be blank' do
    set_password ''
    @user.should_not be_valid
    @user.errors.should be_invalid('password')
  end

  it 'password can be just right' do
    set_password 'Just right'
    @user.should be_valid
  end

  it 'login cannot be too short' do
    @user.login = 'x'
    @user.should_not be_valid
    @user.errors.should be_invalid('login')
  end

  it 'login cannot be too long' do
    @user.login = 'repetitivebob' * 10
    @user.should_not be_valid
    @user.errors.should be_invalid('login')
  end

  it 'login cannot be blank' do
    @user.login = ''
    @user.should_not be_valid
    @user.errors.should be_invalid('login')
  end

  it 'login can be just right' do
    @user.login = 'okbob'
    @user.should be_valid
  end

  it 'email cannot be blank' do
    @user.email = ''
    @user.should_not be_valid
  end

  def set_password(newpass)
    @user.password = @user.password_confirmation = newpass
  end
end

describe 'With a user, "bob" in the database' do
  before(:each) do
    User.delete_all
    u = User.new(:login => 'bob')
    u.password = u.password_confirmation = 'secure password'
    u.email = 'typo@typo.com' #Email needed
    u.save!
  end

  it 'should not be able to create another user with the same login' do
    u = User.new(:login => 'bob') {|u| u.password = u.password_confirmation = 'secure password'}

    u.should_not be_valid
    u.errors.should be_invalid('login')
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
