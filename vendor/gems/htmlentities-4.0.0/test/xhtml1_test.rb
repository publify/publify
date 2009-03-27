$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'htmlentities'
require 'test/unit'

$KCODE = 'u'

class HTMLEntities::XHTML1Test < Test::Unit::TestCase

  attr_reader :html_entities

  def setup
    @html_entities = HTMLEntities.new('xhtml1')
  end

  def test_should_encode_apos_entity
    assert_equal "&apos;", html_entities.encode("'", :basic)
  end

  def test_should_decode_apos_entity
    assert_equal "é'", html_entities.decode("&eacute;&apos;")
  end

end
