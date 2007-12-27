# License: see LICENSE.txt
#  Jabber4R - Jabber Instant Messaging Library for Ruby
#  Copyright (C) 2002  Rich Kilmer <rich@infoether.com>
# 


module Jabber

  ##
  # The VCard class holds the parsed VCard data from the Jabber service.
  #
  class VCard
    attr_accessor :given, :family, :middle, :nickname, :email
    
    ##
    # Factory to create the VCard from the ParsedXMLElement
    #
    # je:: [ParsedXMLElement] The VCard as an xml element.
    # return:: [Jabber::VCard] The newly created VCard.
    #
    def VCard.from_element(je)
      card = VCard.new
      return card unless je
      card.given = je.N.GIVEN.element_data
      card.family = je.N.FAMILY.element_data
      card.middle = je.N.MIDDLE.element_data
      card.email = je.EMAIL.element_data
      card.nickname = je.NICKNAME.element_data
      return card
    end
    
    ##
    # Dumps the attributes of the VCard
    # 
    # return:: [String] The VCard as a string.    #
    def to_s
      "VCARD: [first=#{@given} last=#{@family} nick=#{@nickname} email=#{@email}]"
    end
  end
  
end

