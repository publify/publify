require 'htmlentities/legacy'

#
# HTML entity encoding and decoding for Ruby
#

class HTMLEntities

  VERSION = '4.0.0'
  FLAVORS = %w[html4 xhtml1]
  INSTRUCTIONS = [:basic, :named, :decimal, :hexadecimal]

  class InstructionError < RuntimeError
  end
  class UnknownFlavor < RuntimeError
  end

  #
  # Create a new HTMLEntities coder for the specified flavor.
  # Available flavors are 'html4' and 'xhtml1' (the default).
  # The only difference in functionality between the two is in the handling of the apos
  # (apostrophe) named entity, which is not defined in HTML4.
  #
  def initialize(flavor='xhtml1')
    @flavor = flavor.to_s.downcase
    raise UnknownFlavor, "Unknown flavor #{flavor}" unless FLAVORS.include?(@flavor)
  end

  #
  # Decode entities in a string into their UTF-8
  # equivalents.  Obviously, if your string is not already in UTF-8, you'd
  # better convert it before using this method, or the output will be mixed
  # up.
  #
  # Unknown named entities will not be converted
  #
  def decode(source)
    return source.to_s.gsub(named_entity_regexp) {
      (cp = map[$1]) ? [cp].pack('U') : $&
    }.gsub(/&#([0-9]{1,7});|&#x([0-9a-f]{1,6});/i) {
      $1 ? [$1.to_i].pack('U') : [$2.to_i(16)].pack('U')
    }
  end

  #
  # Encode codepoints into their corresponding entities.  Various operations
  # are possible, and may be specified in order:
  #
  # :basic :: Convert the five XML entities ('"<>&)
  # :named :: Convert non-ASCII characters to their named HTML 4.01 equivalent
  # :decimal :: Convert non-ASCII characters to decimal entities (e.g. &#1234;)
  # :hexadecimal :: Convert non-ASCII characters to hexadecimal entities (e.g. # &#x12ab;)
  #
  # You can specify the commands in any order, but they will be executed in
  # the order listed above to ensure that entity ampersands are not
  # clobbered and that named entities are replaced before numeric ones.
  #
  # If no instructions are specified, :basic will be used.
  #
  # Examples:
  #   encode_entities(str) - XML-safe
  #   encode_entities(str, :basic, :decimal) - XML-safe and 7-bit clean
  #   encode_entities(str, :basic, :named, :decimal) - 7-bit clean, with all
  #   non-ASCII characters replaced with their named entity where possible, and
  #   decimal equivalents otherwise.
  #
  # Note: It is the program's responsibility to ensure that the source
  # contains valid UTF-8 before calling this method.
  #
  def encode(source, *instructions)
    string = source.to_s.dup
    if (instructions.empty?)
      instructions = [:basic]
    elsif (unknown_instructions = instructions - INSTRUCTIONS) != []
      raise InstructionError,
      "unknown encode_entities command(s): #{unknown_instructions.inspect}"
    end
    
    basic_entity_encoder =
    if instructions.include?(:basic) || instructions.include?(:named)
      :encode_named
    elsif instructions.include?(:decimal)
      :encode_decimal
    else instructions.include?(:hexadecimal)
      :encode_hexadecimal
    end
    string.gsub!(basic_entity_regexp){ __send__(basic_entity_encoder, $&) }
    
    extended_entity_encoders = []
    if instructions.include?(:named)
      extended_entity_encoders << :encode_named
    end
    if instructions.include?(:decimal)
      extended_entity_encoders << :encode_decimal
    elsif instructions.include?(:hexadecimal)
      extended_entity_encoders << :encode_hexadecimal
    end
    unless extended_entity_encoders.empty?
      string.gsub!(extended_entity_regexp){
        encode_extended(extended_entity_encoders, $&)
      }
    end
    
    return string
  end

private

  def map
    @map ||= (require "htmlentities/#{@flavor}"; HTMLEntities::MAPPINGS[@flavor])
  end

  def basic_entity_regexp
    @basic_entity_regexp ||= (
      case @flavor
      when /^html/
        /[<>"&]/
      else
        /[<>'"&]/
      end
    )
  end
  
  def extended_entity_regexp
    @extended_entity_regexp ||= (
      regexp = '[\x00-\x1f]|[\xc0-\xfd][\x80-\xbf]+'
      regexp += "|'" if @flavor == 'html4'
      Regexp.new(regexp)
    )
  end

  def named_entity_regexp
    @named_entity_regexp ||= (
      min_length = map.keys.map{ |a| a.length }.min
      max_length = map.keys.map{ |a| a.length }.max
      /&([a-z][a-z0-9]{#{min_length-1},#{max_length-1}});/i
    )
  end

  def reverse_map
    @reverse_map ||= map.invert
  end

  def encode_named(char)
    cp = char.unpack('U')[0]
    (e = reverse_map[cp]) && "&#{e};"
  end

  def encode_decimal(char)
    "&##{char.unpack('U')[0]};"
  end

  def encode_hexadecimal(char)
    "&#x#{char.unpack('U')[0].to_s(16)};"
  end
  
  def encode_extended(encoders, char)
    encoders.each do |encoder|
      encoded = __send__(encoder, char)
      return encoded if encoded
    end
    return char
  end

end
