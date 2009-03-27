$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'htmlentities'
require 'test/unit'

$KCODE = 'u'

#
# Test that version 3.x functionality still works
#
class HTMLEntities::LegacyTest < Test::Unit::TestCase
  
  def test_should_decode_via_legacy_interface
    assert_decode('&', '&amp;')
    assert_decode('±', '&plusmn;')
    assert_decode('“', '&#8220;')
    assert_decode('—', '&#x2014;')
  end

  def test_should_encode_via_legacy_interface
    assert_encode('&amp;', '&', :basic)
    assert_encode('&eth;', 'ð', :named)
    assert_encode('&#8230;', '…', :decimal)
    assert_encode('&#x2212;', '−', :hexadecimal)
  end
  
  def assert_encode(expected, *encode_args)
    assert_equal expected, HTMLEntities.encode_entities(*encode_args)
  end

  def assert_decode(expected, *decode_args)
    assert_equal expected, HTMLEntities.decode_entities(*decode_args)
  end
  
end