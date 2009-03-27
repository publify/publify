$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'htmlentities'
require 'test/unit'

$KCODE = 'u'

class HTMLEntities::EntitiesTest < Test::Unit::TestCase

  attr_reader :xhtml1_entities, :html4_entities

  def setup
    @xhtml1_entities = HTMLEntities.new('xhtml1')
    @html4_entities = HTMLEntities.new('html4')
  end

  class PseudoString
    def initialize(string)
      @string = string
    end
    def to_s
      @string
    end
  end
  
  def test_should_raise_exception_when_unknown_flavor_specified
    assert_raises(HTMLEntities::UnknownFlavor) do
      HTMLEntities.new('foo')
    end
  end

  def test_should_allow_symbol_for_flavor
    assert_nothing_raised do
      HTMLEntities.new(:xhtml1)
    end
  end

  def test_should_allow_upper_case_flavor
    assert_nothing_raised do
      HTMLEntities.new('XHTML1')
    end
  end

  def test_should_decode_basic_entities
    assert_decode('&', '&amp;')
    assert_decode('<', '&lt;')
    assert_decode('"', '&quot;')
  end

  def test_should_encode_basic_entities
    assert_encode('&amp;', '&', :basic)
    assert_encode('&quot;', '"')
    assert_encode('&lt;', '<', :basic)
    assert_encode('&lt;', '<')
  end
  
  def test_should_encode_basic_entities_to_decimal
    assert_encode('&#38;', '&', :decimal)
    assert_encode('&#34;', '"', :decimal)
    assert_encode('&#60;', '<', :decimal)
    assert_encode('&#62;', '>', :decimal)
    assert_encode('&#39;', "'", :decimal)
  end

  def test_should_encode_basic_entities_to_hexadecimal
    assert_encode('&#x26;', '&', :hexadecimal)
    assert_encode('&#x22;', '"', :hexadecimal)
    assert_encode('&#x3c;', '<', :hexadecimal)
    assert_encode('&#x3e;', '>', :hexadecimal)
    assert_encode('&#x27;', "'", :hexadecimal)
  end

  def test_should_decode_extended_named_entities
    assert_decode('±', '&plusmn;')
    assert_decode('ð', '&eth;')
    assert_decode('Œ', '&OElig;')
    assert_decode('œ', '&oelig;')
  end

  def test_should_encode_extended_named_entities
    assert_encode('&plusmn;', '±', :named)
    assert_encode('&eth;', 'ð', :named)
    assert_encode('&OElig;', 'Œ', :named)
    assert_encode('&oelig;', 'œ', :named)
  end

  def test_should_decode_decimal_entities
    assert_decode('“', '&#8220;')
    assert_decode('…', '&#8230;')
    assert_decode(' ', '&#32;')
  end

  def test_should_encode_decimal_entities
    assert_encode('&#8220;', '“', :decimal)
    assert_encode('&#8230;', '…', :decimal)
  end

  def test_should_decode_hexadecimal_entities
    assert_decode('−', '&#x2212;')
    assert_decode('—', '&#x2014;')
    assert_decode('`', '&#x0060;')
    assert_decode('`', '&#x60;')
  end

  def test_should_encode_hexadecimal_entities
    assert_encode('&#x2212;', '−', :hexadecimal)
    assert_encode('&#x2014;', '—', :hexadecimal)
  end

  def test_should_decode_text_with_mix_of_entities
    # Just a random headline - I needed something with accented letters.
    assert_decode(
      'Le tabac pourrait bientôt être banni dans tous les lieux publics en France',
      'Le tabac pourrait bient&ocirc;t &#234;tre banni dans tous les lieux publics en France'
    )
    assert_decode(
      '"bientôt" & 文字',
      '&quot;bient&ocirc;t&quot; &amp; &#25991;&#x5b57;'
    )
  end

  def test_should_encode_text_using_mix_of_entities
    assert_encode(
      '&quot;bient&ocirc;t&quot; &amp; &#x6587;&#x5b57;',
      '"bientôt" & 文字', :basic, :named, :hexadecimal
    )
    assert_encode(
      '&quot;bient&ocirc;t&quot; &amp; &#25991;&#23383;',
      '"bientôt" & 文字', :basic, :named, :decimal
    )
  end

  def test_should_sort_commands_when_encoding_using_mix_of_entities
    assert_encode(
      '&quot;bient&ocirc;t&quot; &amp; &#x6587;&#x5b57;',
      '"bientôt" & 文字', :named, :hexadecimal, :basic
    )
    assert_encode(
      '&quot;bient&ocirc;t&quot; &amp; &#25991;&#23383;',
      '"bientôt" & 文字', :decimal, :named, :basic
    )
  end

  def test_should_detect_illegal_encoding_command
    assert_raise(HTMLEntities::InstructionError) {
      HTMLEntities.encode_entities('foo', :bar, :baz)
    }
  end

  def test_should_decode_empty_string
    assert_decode('', '')
  end

  def test_should_skip_unknown_entity
    assert_decode('&bogus;', '&bogus;')
  end

  def test_should_decode_double_encoded_entity_once
    assert_decode('&amp;', '&amp;amp;')
  end

  def test_should_not_encode_normal_ASCII
    assert_encode('`', '`')
    assert_encode(' ', ' ')
  end

  def test_should_double_encode_existing_entity
    assert_encode('&amp;amp;', '&amp;')
  end

  # Faults found and patched by Moonwolf
  def test_should_decode_full_hexadecimal_range
    (0..127).each do |codepoint|
      assert_decode([codepoint].pack('U'), "&\#x#{codepoint.to_s(16)};")
    end
  end

  # Reported by Dallas DeVries and Johan Duflost
  def test_should_decode_named_entities_reported_as_missing_in_3_0_1
    assert_decode([178].pack('U'), '&sup2;')
    assert_decode([8226].pack('U'), '&bull;')
    assert_decode([948].pack('U'), '&delta;')
  end

  def test_should_ducktype_parameter_to_string_before_encoding
    pseudo_string = PseudoString.new('foo')
    assert_decode('foo', pseudo_string)
  end

  def test_should_ducktype_parameter_to_string_before_decoding
    pseudo_string = PseudoString.new('foo')
    assert_encode('foo', pseudo_string)
  end

  def assert_decode(expected, input)
    [xhtml1_entities, html4_entities].each do |coder|
      assert_equal(expected, coder.decode(input))
    end
  end

  def assert_encode(expected, input, *args)
    [xhtml1_entities, html4_entities].each do |coder|
      assert_equal(expected, coder.encode(input, *args))
    end
  end

end
