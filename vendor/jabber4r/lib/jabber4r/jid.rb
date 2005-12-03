# License: see LICENSE.txt
#  Jabber4R - Jabber Instant Messaging Library for Ruby
#  Copyright (C) 2002  Rich Kilmer <rich@infoether.com>
# 

module Jabber

  ##
  # The Jabber ID class is used to hold a parsed jabber identifier (account+host+resource)
  #
  class JID
  
    # The node (account)
    attr_accessor :node
    
    # The resource id
    attr_accessor :resource
    
    # The host name (or IP address)
    attr_accessor :host
    
    def JID.to_jid(id)
      return id if id.kind_of? JID
      return JID.new(id)
    end
    
    #@@Pattern = /([^@""'\s:]+)\@([-.\w]+)\/?(.*)/
    
    ##
    # Constructs a JID from the supplied string of the format:
    #    node@host[/resource] (e.g. "rich_kilmer@jabber.com/laptop")
    #
    # id:: [String] The jabber id string to parse
    #
    def initialize(id)
      at_loc = id.index('@')
      slash_loc = id.index('/')
      if at_loc.nil? and slash_loc.nil?
        @host = id
      end
      if at_loc
        @node = id[0,at_loc]
        host_end = slash_loc ? slash_loc-(at_loc+1) : id.size-(at_loc+1)
        @host = id[at_loc+1,host_end]
        @resource = id[slash_loc+1, id.size] if slash_loc
      end
    end
    
    ##
    # Evalutes whether the node, resource and host are the same
    #
    # other:: [Jabber::JID] The other jabber id
    # return:: [Boolean] True if they match
    def ==(other)
      return true if other.node==@node and other.resource==@resource and other.host==@host
      return false
    end
    
    def same_account?(other)
      other = JID.to_jid(other)
      return true if other.node==@node  and other.host==@host
       return false
    end
    
    ##
    # Removes the resource from this JID
    #
    def strip_resource
      @resource=nil
      return self
    end
    
    ##
    # Returns the string ("node@host/resource") representation of this JID
    #
    # return:: [String] String form of JID
    #
    def to_s
      result = (@node.to_s+"@"+@host.to_s)
      result += ("/"+@resource) if @resource
      return result
    end
    
    ##
    # Override #hash to hash based on the to_s method
    #
    def hash
      return to_s.hash
    end
  end
  
end

