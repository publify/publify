# License: see LICENSE.txt
#  Jabber4R - Jabber Instant Messaging Library for Ruby
#  Copyright (C) 2002  Rich Kilmer <rich@infoether.com>
# 


module Jabber

  ##
  # The Roster class encapsulates the runtime roster of the session instance.
  # The Roster contains all subscriptions in a Jabber::Roster::RosterItem hash.
  # 
  class Roster
    ITEM_ADDED=1
    ITEM_DELETED=2
    RESOURCE_ADDED=4
    RESOURCE_UPDATED=8
    RESOURCE_DELETED=16
    
    # The Jabber::Session instance
    attr_reader :session
    
    ##
    # Creates a Roster for the session
    #
    # session:: [Jabber::Session] The session instance
    #
    def initialize(session)
      @session = session
      @map = {}
      @listeners = {}
    end
    
    ##
    # The RosterItem class embodies another Jabber user's status (from
    # the local user's perspective).  RosterItems contain 
    # Jabber::Roster::RosterItem::Resource objects for each resource
    # location a foreign user is accessing through.
    #
    class RosterItem
      # The Jabber::Roster instance
      attr_reader :roster
      
      # The Jabber ID (Jabber::JID)
      attr_accessor :jid
      
      # The subscription type
      attr_accessor :subscription
      
      # The (nick)name of this account
      attr_accessor :name
      
      # The group name for this account
      attr_accessor :group
      
      ##
      # Constructs a RosterItem
      #
      # roster:: [Jabber::Roster] The roster instance
      # subscription:: [String] The subscription type
      # name:: [String] The (nick)name
      # group:: [String=nil] The group this account belongs to
      #
      def initialize(roster, jid, subscription, name, group=nil)
        @jid = jid
        @subscription = subscription
        @name = name
        @group = group if group
        @resources = {}
        @roster = roster
      end
      
      ##
      # The Resource class embodies a Resource endpoint in Jabber.
      # The resource endpoint it what maintains a status (not an account).
      #
      class Resource
      
        # The name of the resource
        attr_reader :name
        
        # How the resource should be shown
        attr_reader :show
        
        # The status message of the resource
        attr_reader :status
        
        ##
        # Constructs a new Resource instance
        #
        # item:: [Jabber::Roster::RosterItem] The roster item this resource belongs to
        # name:: [String] The resource name
        # show:: [String] How the resource should be shown
        # status:: [String] The status message of the resource
        #
        def initialize(item, name, show, status)
          @item = item
          @name = name
          @show = show
          @status = status
        end
        
        ##
        # Updates the state of a resource and notifies listeners.
        #
        # show:: [String] How the resource should be shown
        # status:: [String] The status message of the resource
        #
        def update(show, status)
          @show = show
          @status = status
          @item.roster.notify_listeners(RESOURCE_UPDATED, self)
        end
        
        ##
        # Dumps the Resource as a string
        #
        # return:: [String] The resource encoded as a string.
        #
        def to_s
          "RESOURCE:#{@name} SHOW:#{@show} STATUS:#{@status}"
        end
      end
      
      ##
      # Retrieves the VCard for this (RosterItem) account.  This method
      # blocks until the the vcard is returned.
      #
      # return:: [Jabber::VCard] The VCard object for this account
      #
      def get_vcard
        ct = Thread.current
        queryID = @roster.session.id
        result = nil
        @roster.session.connection.send(Jabber::Protocol::Iq.gen_vcard(self, queryID, jid)) { |je|
            if je.element_tag == "iq" and je.attr_type=="result" and je.attr_id == queryID
              je.consume_element
              result = Jabber::VCard.from_element(je.VCARD)
              ct.wakeup
            else
            end
        }
        Thread.stop
        return result
      end
      
      ##
      # Adds a new resource to the Roster item and notifies listeners
      #
      # resourceName:: [String] The name of the resource
      # show:: [String] How the resource is to be viewed
      # status:: [String] The status message
      # return:: [Jabber::Roster:RosterItem::Resource] The new Resource instance
      #
      def add(resourceName, show, status)
        resource = Resource.new(self, resourceName, show, status)
        @resources[resourceName] = resource
        @roster.notify_listeners(RESOURCE_ADDED, resource)
        resource
      end
      
      ##
      # Deletes a resource from this roster item and notifies listeners
      #
      # resourceName:: [String] The name of the resource
      # return:: [Jabber::Roster:RosterItem::Resource] The deleted Resource
      #
      def delete(resourceName)
        resource = @resources.delete(resourceName)
        @roster.notify_listeners(RESOURCE_DELETED, resource) if resource
        resource
      end
      
      ##
      # Retrieves a resource object
      #
      # resourceName:: [String] The name of the resource
      # return:: [Jabber::Roster:RosterItem::Resource] The Resource instance
      #
      def [](resourceName)
        return @resources[resourceName]
      end
      
      ##
      # Iterates over the list of available resources
      #
      # yield:: |Jabber::Roster:RosterItem::Resource| The resource instance
      #
      def each_resource
        @resources.each_value {|resource| yield resource}
      end
      
      ##
      # Dumps the roster item
      #
      # return:: [String] The roster item dumped as a String
      def to_s
        "ITEM:#{@jid.to_s} SUBSCRIPTION:#{@subscription} NAME:#{@name} GROUP:#{@group}"
      end
    end
    
    ##
    # Adds a listener to the roster to process roster changes
    #
    # &block:: [Block |event, rosteritem|] The block to process roster changes
    # return:: [String] The listener id to use to deregister
    #
    def add_listener(&block)
      id = Jabber.gen_random_id("", 10)
      @listeners[id]=block if block
      return id
    end
    
    ##
    # Deletes a listener for processing roster messages
    #
    # id:: [String] A listener id (given by add_listener)
    #
    def delete_listener(id)
      @listeners.delete(id)
    end
    
    ##
    # Adds a subscription to be tracked in the Roster
    #
    # jid:: [JID | String] The Jabber ID
    # subscription:: [String] The subscription type (both)
    # name:: [String] The nickname
    # group:: [String = nil] The name of the group of the roster item.
    #
    def add(jid, subscription, name, group=nil)
      if jid.kind_of? String
        jid = JID.new(jid) 
        jid.strip_resource
      elsif jid.kind_of? JID
        jid = JID.new(jid.node+"@"+jid.host)
      else
        return
      end
      begin
        item = RosterItem.new(self, jid, subscription, name, group)
        @map[jid.to_s] = item
        notify_listeners(ITEM_ADDED, item)
      rescue => ex
        puts ex.backtrace.join("\n")
      end
    end
    
    ##
    # Returns a Jabber::Roster::RosterItem based on the JID
    #
    # jid:: [Jabber::JID | String] The Jabber ID
    # return:: [Jabber::Roster::RosterItem] The roster item
    #
    def [](jid)
      if jid.kind_of? String
        jid = JID.new(jid) 
        jid.strip_resource
      elsif jid.kind_of? JID
        jid = JID.new(jid.node+"@"+jid.host)
      else
        return
      end
      return @map[jid.to_s]
    end
    
    ##
    # Deletes a roster item based on the supplied Jabber ID
    #
    # jid:: [Jabber::JID | String]
    #
    def delete(jid)
      if jid.kind_of? String
        jid = JID.new(jid) 
        jid.strip_resource
      elsif jid.kind_of? JID
        jid = JID.new(jid.node+"@"+jid.host)
      else
        return
      end
      item = @map.delete(jid.to_s)
      notify_listeners(ITEM_DELETED, item) if item
      item
    end
    
    ##
    # Iterates over each RosterItem
    #
    # yield:: [Jabber::Roster::RosterItem] The roster item.
    #
    def each_item
      @map.each_value {|item| yield item}
    end
    
    ##
    # Dumps the Roster state as a string
    #
    # return:: [String] The roster state
    #
    def to_s
      result = "ROSTER DUMP\n"
      each_item do |item|
        result += (item.to_s+"\n")
        item.each_resource {|resource| result+= "    #{resource.to_s}\n"}
      end
      return result
    end

    ##
    # Notifies listeners of a roster change event
    # 
    # event:: [Integer] The roster event
    # object:: [RosterItem] The modified item
    #
    def notify_listeners(event, object)
      @listeners.each_value {|listener| listener.call(event, object)}
    end
    
  end
  
end

