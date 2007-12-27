# License: see LICENSE.txt
#  Jabber4R - Jabber Instant Messaging Library for Ruby
#  Copyright (C) 2002  Rich Kilmer <rich@infoether.com>
# 


module Jabber
  HEX = "0123456789abcdef"
  
  ##
  # Generates a random hex string in the following format:
  #   JRR_01234567
  #
  # return:: [String] The resource id
  #
  def Jabber.gen_random_resource
    return Jabber.gen_random_id("JRR_", 8)
  end
  
  ##
  # Generates a random thread as a hex string in the following format:
  #   JRT_01234567890123456789
  #
  # return:: [String] The thread id
  #
  def Jabber.gen_random_thread
    return Jabber.gen_random_id("JRT_", 20)
  end
  
  ##
  # Generates a random id as a hex string
  #
  # prefix:: [String="Jabber4R_] The prefix for the random hex data
  # length:: [Integer=16] The number of hex characters
  # return:: [String] The random id
  #
  def Jabber.gen_random_id(prefix="Jabber4R_", length=16)
    length.times {prefix += HEX[rand(16),1]}
    prefix
  end
  
  class Subscription
    attr_accessor :type, :from, :id, :session
    def initialize(session, type, from, id)
      @session = session
      @type = type
      @from = from
      @id = id
    end
    def accept
      case type
      when :subscribe
        @session.connection.send(Jabber::Protocol::Presence.gen_accept_subscription(@id, @from))
      when :unsubscribe
        @session.connection.send(Jabber::Protocol::Presence.gen_accept_unsubscription(@id, @from))
      else
        raise "Cannot accept a subscription of type #{type.to_s}"
      end
    end
  end
  
  ##
  # This is a base class for subscription handlers
  
  class SubscriptionHandler
    def subscribe(subscription)
    end
    
    def subscribed(subscription)
    end
    
    def unsubscribe(subscription)
    end
    
    def unsubscribed(subscription)
    end
  end
  
  class AutoSubscriptionHandler < SubscriptionHandler
  
    def subscribe(subscription)
      subscription.accept
    end
    
    def unsubscribe(subscription)
      subscription.accept
    end
  end
    

  ##
  # The Jabber Session is the main class for dealing with a Jabber service.
  #
  class Session
  
    # The host this session is connected to
    attr_reader :host
    
    # The port (defaults to 5222) that this session is connected to
    attr_reader :port
    
    # The Jabber::Protocol::Connection instance
    attr_reader :connection

    # The Jabber::Roster instance
    attr_reader :roster

    # The session id sent from the Jabber service upon connection
    attr_reader :session_id

    # The Jabber::JID of the current session
    attr_reader :jid
    
    # The username to use for authenticating this session
    attr_accessor :username
    
    # The password to use for authenticating this session
    attr_accessor :password
    
    # The resource id for this session
    attr_accessor :resource
    
    # The iq handlers for this session
    attr_accessor :iqHandlers
    
    ##
    # Session creation factory that creates a session, logs in, 
    # requests the roster, registers message and presence filters
    # and announces initial presence.  Login is done via plaintext
    # password authentication.
    #
    # jid:: [String | JID] The account information ("account@host/resouce")
    # password:: [String] The account password
    # port:: [Integer = 5222] The host port
    # digest:: [Boolean = false] Use digest authentication?
    # return:: [Jabber::Session] The new session
    #
    def Session.bind(jid, password, port=5222, digest=false)
      jid = Jabber::JID.new(jid) if jid.kind_of? String
      session = Session.new(jid.host, port)
      raise "Authentication failed" unless session.authenticate(jid.node, password, jid.resource, digest)
      session.request_roster
      session.register_message_filter
      session.register_presence_filter
      session.register_iq_filter
      session.announce_initial_presence
      session
    end
    
    ##
    # Account registration method
    #
    def Session.register(jid, password, email="", name="", port=5222)
      jid = Jabber::JID.new(jid) if jid.kind_of? String
      session = Session.new(jid.host, port)
      msg_id = session.id
      registered = false
      current = Thread.current
      session.connection.send(Jabber::Protocol::Iq.gen_registration(session, msg_id, jid.node, password, email, name)) do |element|
        if element.element_tag=="iq" and element.attr_id==msg_id
          element.consume_element
          if element.attr_type=="result"
            registered = true
          elsif element.attr_type=="error"
            registered = false
          end
          current.wakeup
        end
      end
      Thread.stop
      session.release      
      return registered
    end
    
    ##
    # Session creation factory that creates a session, logs in, 
    # requests the roster, registers message and presence filters
    # and announces initial presence.  Login is done via digest (SHA)
    # password authentication.
    #
    # jid:: [String | JID] The account information ("account@host/resouce")
    # password:: [String] The account password
    # port:: [Integer = 5222] The host port
    # return:: [Jabber::Session] The new session
    #
    def Session.bind_digest(jid, password, port=5222)
      Session.bind(jid, password, port, true)
    end
    
    # Creates a new session connected to the supplied host and port.
    # The method attempts to build a Jabber::Protocol::Connection
    # object and send the open_stream XML message.  It then blocks
    # to recieve the coorisponding reply open_stream and sets the
    # session_id from that xml element.
    #
    # host:: [String] The hostname of the Jabber service
    # port:: [Integer=5222] The port of the Jabber service
    # raise:: [RuntimeException] If connection fails
    #
    def initialize(host, port=5222)
      @id = 1
      @host = host
      @port = port
      @roster = Roster.new(self)
      @messageListeners = Hash.new
      @iqHandlers=Hash.new
      @subscriptionHandler = nil
      @connection = Jabber::Protocol::Connection.new(host, port)
      @connection.connect
      unless @connection.is_connected?
        raise "Session Error: Could not connected to #{host}:#{port}"
      else
        @connection.send(Jabber::Protocol.gen_open_stream(host)) do |element| 
          if element.element_tag=="stream:stream"
            element.consume_element 
            @session_id = element.attr_id
          end
        end
        @connection.on_connection_exception do
          if @session_failure_block
            self.release
            @session_failure_block.call
          end
        end
        Thread.stop
      end
    end
    
    ##
    # Set a handler for session exceptions that get caught in 
    # communicating with the Jabber server.
    #
    def on_session_failure(&block)
      @session_failure_block = block
    end
    
    ##
    # Counter for message IDs
    #
    # return:: [String] A unique message id for this session
    #
    def id
      @id = @id + 1
      return @id.to_s
    end
    
    ##
    # Authenticate (logs into) this session with the supplied credentials.
    # The method blocks waiting for a reply to the login message.  Sets the
    # authenticated attribute based on result.
    #
    # username:: [String] The username to use for authentication
    # password:: [String] The password to use for authentication
    # resource:: [String] The resource ID for this session
    # digest:: [Boolean=false] True to use digest authentication (not sending password in the clear)
    # return:: [Boolean] Whether the authentication succeeded or failed
    #
    def authenticate(username, password, resource, digest=false)
      @username = username
      @password = password
      @resource = resource
      @jid = JID.new("#{username}@#{@host}/#{resource}")
      @roster.add(@jid, "both", "Me", "My Resources")
      
      msg_id = self.id
      authHandler = Proc.new  do |element| 
        if element.element_tag=="iq" and element.attr_id==msg_id
          element.consume_element
          if element.attr_type=="result"
            @authenticated = true
          elsif element.attr_type=="error"
            @authenticated = false
          end
        end
      end
      if digest
        require 'digest/sha1'
        authRequest = Jabber::Protocol::Iq.gen_auth_digest(self, msg_id, username, Digest::SHA1.new(@session_id + password).hexdigest, resource)
      else
        authRequest = Jabber::Protocol::Iq.gen_auth(self, msg_id, username, password, resource)
      end
      @connection.send(authRequest, &authHandler)
      Thread.stop
      return @authenticated
    end
    
    ##
    # Is this an authenticated session?
    #
    # return:: [Boolean] True if the session is authenticated
    #
    def is_authenticated?
      return @authenticated
    end
      
    ##
    # Sends the initial presence message to the Jabber service
    #
    def announce_initial_presence
      @connection.send(Jabber::Protocol::Presence.gen_initial(id))
    end
    
    ##
    # Sends an extended away presence message
    #
    # status:: [String] The status message
    #
    def announce_extended_away(status=nil)
      @connection.send(Jabber::Protocol::Presence.gen_xa(id, status))
    end
    
    ##
    # Sends a free for chat presence message
    #
    # status:: [String] The status message
    #
    def announce_free_for_chat(status=nil)
      @connection.send(Jabber::Protocol::Presence.gen_chat(id, status))
    end
    
    ##
    # Sends a 'normal' presence message
    #
    # status:: [String] The status message
    #
    def announce_normal(status=nil)
      @connection.send(Jabber::Protocol::Presence.gen_normal(id, status))
    end
    
    ##
    # Sends an away from computer presence message
    #
    # status:: [String] The status message
    #
    def announce_away_from_computer(status=nil)
      @connection.send(Jabber::Protocol::Presence.gen_away(id, status))
    end
    
    ##
    # Sends a do not disturb presence message
    #
    # status:: [String] The status message
    #
    def announce_do_not_disturb(status=nil)
      @connection.send(Jabber::Protocol::Presence.gen_dnd(id, status))
    end
    
    ##
    # Sets the handler for subscription requests, notifications, etc.
    #
    def set_subscription_handler(handler=nil, &block)
      @subscriptionHandler = handler.new(self) if handler
      @subscriptionHandler = block if block_given? and !handler
    end
    
    def enable_autosubscription
      set_subscription_handler AutoSubscriptionHandler
    end
    
    def subscribe(to, name="") 
      to = JID.to_jid(to)
      roster_item = @roster[to]
      
      if roster_item #if you already have a roster item just send the subscribe request
        if roster_item.subscription=="to" or roster_item.subscription=="both"
          return
        end
        @connection.send(Jabber::Protocol::Presence.gen_new_subscription(to))
        return
      end
      myid = self.id
      @connection.send(Jabber::Protocol::Iq.gen_add_rosteritem(self, myid, to, name)) do |element|
        if element.attr_id==myid
          element.consume_element
          if element.attr_type=="result"
            @connection.send(Jabber::Protocol::Presence.gen_new_subscription(to))
          end
        end
      end
    end
    
    ##
    # Adds a filter to the Connection to manage tracking resources that come online/offline
    #
    def register_presence_filter
      @connection.add_filter("presenceAvailableFilter") do |element|
        if element.element_tag=="presence"
          type = element.attr_type
          type = nil if type.nil?
          case type
          when nil, "available"
            element.consume_element
            from = JID.new(element.attr_from)
            rItem = @roster[from]
            show = element.show.element_data
            show = "chat" unless show
            status = element.status.element_data
            status = "" unless status
            if rItem
              resource = rItem[from.resource]
              if resource
                resource.update(show, status)
              else
                rItem.add(from.resource, show, status)
              end
            end
          when "unavailable"
            element.consume_element
            from = JID.new(element.attr_from)
            rItem = @roster[from]
            resource = rItem.delete(from.resource) if rItem
          when "subscribe", "unsubscribe", "subscribed", "unsubscribed"
            element.consume_element
            from = JID.new(element.attr_from)
            break unless @subscriptionHandler
            if @subscriptionHandler.kind_of? Proc
              @subscriptionHandler.call(Subscription.new(self, type.intern, from, id))
            else
              @subscriptionHandler.send(Subscription.new(self, type.intern, from, id))
            end
          end
        end #if presence 
      end #do
    end
    
    ##
    # Creates a new message to the supplied JID of type NORMAL
    # 
    # to:: [Jabber::JID] Who to send the message to
    # type:: [String = Jabber::Protocol::Message::NORMAL] The type of message to send (see Jabber::Protocol::Message)
    # return:: [Jabber::Protocol::Message] The new message
    #
    def new_message(to, type=Jabber::Protocol::Message::NORMAL)
      msg = Jabber::Protocol::Message.new(to, type)
      msg.session=self
      return msg
    end
    
    ##
    # Creates a new message addressed to the supplied JID of type CHAT
    #
    # to:: [JID] Who to send the message to
    # return:: [Jabber::Protocol::Message] The new (chat) message
    #
    def new_chat_message(to)
      self.new_message(to, Jabber::Protocol::Message::CHAT)
    end
    
    ##
    # Creates a new message addressed to the supplied JID of type GROUPCHAT
    #
    # to:: [JID] Who to send the message to
    # return:: [Jabber::Protocol::Message] The new (group chat) message
    #
    def new_group_chat_message(to)
      self.new_message(to, Jabber::Protocol::Message::GROUPCHAT)
    end
    
    ##
    # Adds a filter to the Connection to manage tracking messages to forward
    # to registered message listeners.
    #
    def register_message_filter
      @connection.add_filter("messageFilter") do |element|
        if element.element_tag=="message" and @messageListeners.size > 0
          element.consume_element
          message = Jabber::Protocol::Message.from_element(self, element)
          notify_message_listeners(message)
        end #if message 
      end #do
    end
    
    ##
    # Add a listener for new messages
    #
    # Usage::
    #    id = session.add_message_listener do |message|
    #      puts message
    #    end
    # 
    # &block [Block] The block to process a message
    # return:: [String] The listener ID...used to remove the listener
    #
    def add_message_listener(&block)
      id = Jabber.gen_random_id("", 10)
      @messageListeners[id]=block if block
      return id
    end
    
    ##
    # Deletes a message listener
    #
    # id:: [String] A messanger ID returned from add_message_listener
    #
    def delete_message_listener(lid)
      @messageListeners.delete(lid)
    end
    
    #Cleanup methods
    
    ##
    # Releases the connection and resets the session.  The Session instance
    # is no longer usable after this method is called
    #
    def release
      begin
        @connection.on_connection_exception do
          #Do nothing...we are shutting down
        end
        @connection.send(Jabber::Protocol::Presence.gen_unavailable(id))
        @connection.send(Jabber::Protocol.gen_close_stream)
      rescue
        #ignore error
      end
      begin
        @connection.close
      rescue
        #ignore error
      end
    end
    
    ##
    # Same as _release
    #
    def close
      release
    end
    
    ##
    # Requests the Roster for the (authenticated) account.  This method blocks
    # until a reply to the roster request is received.
    #
    def request_roster
      if @authenticated
        msg_id = id
        @connection.send(Jabber::Protocol::Iq.gen_roster(self, msg_id)) do |element|
          if element.attr_id == msg_id
            element.consume_element
            element.query.item.count.times do |i|
              item = element.query.item[i]
              @roster.add(item.attr_jid, item.attr_subscription, item.attr_name, item.group.element_data)
            end
          end
        end
        Thread.stop
        register_roster_filter
      end
    end
    
    ##
    # Registers the roster filter with the Connection to forward IQ requests
    # to the IQ listeners(they register by namespace)
    #
    def register_iq_filter() 
      @connection.add_filter("iqFilter") do |element|
        if element.element_tag=="iq" then
          element.consume_element
          query=element.query
          h=@iqHandlers[query.attr_xmlns]
          h.call(Jabber::Protocol::Iq.from_element(self,element)) if h
        end
      end
    end
    
    
    ##
    # Registers the roster filter with the Connection to forward roster changes to
    # the roster listeners.
    #
    def register_roster_filter
      @connection.add_filter("rosterFilter") do |element|
        if element.element_tag=="iq" and element.query.attr_xmlns=="jabber:iq:roster" and element.attr_type=="set"
          element.consume_element
          item = element.query.item
          if item.attr_subscription=="remove" then
            @roster.remove(item.attr_jid)
          else
            @roster.add(item.attr_jid, item.attr_subscription, item.attr_name, item.group.element_data)
          end
        end
      end
    end
    
    ##
    # Registers a listener for roster events
    #
    # &block:: [Block] The listener block to process roster changes
    # return:: [String] A roster ID to use when removing this listener
    #
    def add_roster_listener(&block)
      roster.add_listener(&block)
    end
    
    ##
    # Deletes the roster listener
    #
    # id:: [String] A roster ID received from the add_roster_listener method
    #
    def delete_roster_listener(id)
      roster.delete_listener(id)
    end
    
    ##
    # Notifies message listeners of the received message
    #
    # message:: [Jabber::Protocol::Message] The received message
    #
    def notify_message_listeners(message)
      @messageListeners.each_value {|listener| listener.call(message)}
    end

  end  
  
end

