require File.dirname(__FILE__) + '/../spec_helper'

context 'With the contents and users fixtures loaded' do
  fixtures :users, :contents, :blogs

  setup do
    User.stub!(:salt).and_return('change-me')
  end

  specify 'Calling User.authenticate with a valid user/password combo returns a user' do
    User.authenticate('bob', 'test').should == users(:bob)
  end

  specify 'User.authenticate(user,invalid) returns nil' do
    User.authenticate('bob', 'wrong password').should_be nil
  end

  specify 'User.authenticate(invalid,whatever) returns nil' do
    User.authenticate('userwhodoesnotexist', 'what ever').should_be nil
  end

  specify 'The various article finders work appropriately' do
    User.find(1).articles.size.should == 8
#    User.find(1).articles.find_published.size.should == Article.find(:all, :conditions => {:published => true}).size
    User.find(1).articles.published.size == 7
  end

  specify 'authenticate? works as expected' do
    User.should_authenticate('bob', 'test')
    User.should_not_authenticate('bob', 'duff password')
  end
end

context 'With a new user' do
  setup do
    @user = User.new :login => 'not_bob'
    set_password 'a secure password'
  end

  specify 'password cannot be too short' do
    set_password 'tiny'
    @user.should_not_be_valid
    @user.errors.should_be_invalid('password')
  end

  specify 'password cannot be too long' do
    set_password 'x' * 80
    @user.should_not_be_valid
    @user.errors.should_be_invalid('password')
  end

  specify 'password cannot be blank' do
    set_password ''
    @user.should_not_be_valid
    @user.errors.should_be_invalid('password')
  end

  specify 'password can be just right' do
    set_password 'Just right'
    @user.should_be_valid
  end

  specify 'login cannot be too short' do
    @user.login = 'x'
    @user.should_not_be_valid
    @user.errors.should_be_invalid('login')
  end

  specify 'login cannot be too long' do
    @user.login = 'repetitivebob' * 10
    @user.should_not_be_valid
    @user.errors.should_be_invalid('login')
  end

  specify 'login cannot be blank' do
    @user.login = ''
    @user.should_not_be_valid
    @user.errors.should_be_invalid('login')
  end

  specify 'login can be just right' do
    @user.login = 'okbob'
    @user.should_be_valid
  end

  def set_password(newpass)
    @user.password = @user.password_confirmation = newpass
  end
end

context 'With a user, "bob" in the database' do
  setup do
    User.delete_all
    u = User.new(:login => 'bob')
    u.password = u.password_confirmation = 'secure password'
    u.save!
  end

  specify 'should not be able to create another user with the same login' do
    u = User.new(:login => 'bob') {|u| u.password = u.password_confirmation = 'secure password'}

    u.should_not_be_valid
    u.errors.should_be_invalid('login')
  end
end
