require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

  fixtures :users, :contents, :profiles

  def test_auth
    assert_equal  users(:bob), User.authenticate("bob", "test")
    assert_nil    User.authenticate("nonbob", "test")
  end

  def test_articles_link
    assert_equal 8, User.find(1).articles.size
    assert_equal 7, User.find(1).articles.find_published.size
    assert_equal 7, User.find(1).articles.published.size

    articles = User.find(1).articles.published
    assert_equal articles.sort_by { |a| a.created_at }.reverse, articles

    articles = User.find(1).articles
    assert_equal articles.sort_by { |a| a.created_at }.reverse, articles
  end

  def test_authenticate?
    assert User.authenticate?("bob", "test")
    assert !User.authenticate?("bob", "wrong password")
    assert User.authenticate?("tobi", "whatever")
    assert !User.authenticate?("tobi", "not whatever")
  end

  def test_disallowed_passwords
    u = User.new
    u.login = "nonbob"

    u.password = u.password_confirmation = "tiny"
    assert !u.save
    assert u.errors.invalid?('password')

    u.password = u.password_confirmation = "hugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehuge"
    assert !u.save
    assert u.errors.invalid?('password')

    u.password = u.password_confirmation = ""
    assert !u.save
    assert u.errors.invalid?('password')

    u.password = u.password_confirmation = "bobs_secure_password"
    assert u.save
    assert u.errors.empty?

  end

  def test_bad_logins
    u = User.new
    u.password = u.password_confirmation = "bobs_secure_password"

    u.login = "x"
    assert !u.save
    assert u.errors.invalid?('login')

    u.login = "hugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhug"
    assert !u.save
    assert u.errors.invalid?('login')

    u.login = ""
    assert !u.save
    assert u.errors.invalid?('login')

    u.login = "okbob"
    assert u.save
    assert u.errors.empty?

  end

  def test_change_name
    u = User.new
    u.password = u.password_confirmation = "a_password"
    u.login = 'xxx'
    assert u.save

    u.password = u.password_confirmation = ''
    u.name = 'X X X'
    u.email = 'x@example.com'
    assert u.save
  end

  def test_collision
    u = User.new
    u.login      = "existingbob"
    u.password = u.password_confirmation = "bobs_secure_password"
    assert !u.save
  end


  def test_create
    u = User.new
    u.login      = "nonexistingbob"
    u.password = u.password_confirmation = "bobs_secure_password"

    assert u.save
  end

  def test_sha1
    u = User.new
    u.login      = "nonexistingbob"
    u.password = u.password_confirmation = "bobs_secure_password"
    assert u.save

    assert_equal '98740ff87bade6d895010bceebbd9f718e7856bb', u.password
  end
end
