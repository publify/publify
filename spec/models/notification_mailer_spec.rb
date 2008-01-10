require File.dirname(__FILE__) + '/../../test/test_helper'
require File.dirname(__FILE__) + '/../spec_helper'
require 'notification_mailer'

class NotificationMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../../test/fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @controller = nil
    @article = Article.find(contents(:article1).id)
    @user = users(:tobi)

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
  end

  def test_article
    @expected.subject = 'NotificationMailer#article'
    @expected.body    = read_fixture('article')
    @expected.date    = Time.now

#    assert_equal @expected.encoded, NotificationMailer.create_article(@controller, @article, @user).encoded
  end

  def test_comment
    @expected.subject = 'NotificationMailer#comment'
    @expected.body    = read_fixture('comment')
    @expected.date    = Time.now

#    assert_equal @expected.encoded, NotificationMailer.create_comment(@controller, @article, @user).encoded
  end

  def test_trackback
    @expected.subject = 'NotificationMailer#trackback'
    @expected.body    = read_fixture('trackback')
    @expected.date    = Time.now

#    assert_equal @expected.encoded, NotificationMailer.create_trackback(@controller, @article, @user).encoded
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/notification_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
