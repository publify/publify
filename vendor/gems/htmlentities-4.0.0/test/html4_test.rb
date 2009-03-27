$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'htmlentities'
require 'test/unit'

$KCODE = 'u'

class HTMLEntities::HTML4Test < Test::Unit::TestCase

  attr_reader :html_entities

  def setup
    @html_entities = HTMLEntities.new('html4')
  end

  # Found by Marcos Kuhns
  def test_should_not_encode_apos_entity
    assert_equal "'", html_entities.encode("'", :basic)
  end

  def test_should_not_decode_apos_entity
    assert_equal "é&apos;", html_entities.decode("&eacute;&apos;")
  end

end
