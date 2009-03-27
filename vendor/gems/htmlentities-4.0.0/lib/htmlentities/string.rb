require 'htmlentities'

#
# This file extends the String class with methods to allow encoding and decoding of
# HTML/XML entities from/to their corresponding UTF-8 codepoints.
#
class String

  #
  # Decode XML and HTML 4.01 entities in a string into their UTF-8
  # equivalents.
  #
  def decode_entities
    return HTMLEntities.decode_entities(self)
  end
  
  #
  # Encode codepoints in a string into their corresponding entities. See
  # the documentation of HTMLEntities.encode_entities for a list of possible
  # instructions.
  #
  def encode_entities(*instructions)
    return HTMLEntities.encode_entities(self, *instructions)
  end

end