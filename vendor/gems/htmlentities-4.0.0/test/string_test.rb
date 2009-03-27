$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'htmlentities/string'
require 'test/unit'

$KCODE = 'u'

class TestHTMLEntities < Test::Unit::TestCase
  
  def test_string_responds_correctly_to_decode_entities
    assert_equal('±', '&plusmn;'.decode_entities)
  end

  def test_string_responds_correctly_to_encode_entities_with_no_parameters
    assert_equal('&quot;', '"'.encode_entities)
  end

  def test_string_responds_correctly_to_encode_entities_with_multiple_parameters
    assert_equal(
      '&quot;bient&ocirc;t&quot; &amp; &#x6587;&#x5b57;',
      '"bientôt" & 文字'.encode_entities(:basic, :named, :hexadecimal)
    )
  end

end