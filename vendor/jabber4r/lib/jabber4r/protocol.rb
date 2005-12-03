# License: see LICENSE.txt
#  Jabber4R - Jabber Instant Messaging Library for Ruby
#  Copyright (C) 2002  Rich Kilmer <rich@infoether.com>
# 


require 'singleton'
require 'socket'

module Jabber

  class JabberConnectionException < RuntimeError
    attr_reader :data
    
    def initialize(writing, data)
      @writing = writing
      @data = data
    end
    
    def writing?
      @writing
    end
  end
    
  ##
  # The Protocol module contains helper methods for constructing 
  # Jabber protocol elements and classes that implement protocol
  # elements.
  #
  module Protocol
  
    USE_PARSER = :rexml # either :rexml or :xmlparser

    ##
    # The parser to use for stream processing.  The current
    # available parsers are:
    #
    # * Jabber::Protocol::ExpatJabberParser uses XMLParser
    # * Jabber::Protocol::REXMLJabberParser uses REXML
    #
    # return:: [Class] The parser class
    #
    def Protocol.Parser
      if USE_PARSER==:xmlparser
        Jabber::Protocol::ExpatJabberParser
      else
        Jabber::Protocol::REXMLJabberParser
      end
    end
    
    ##
    # The connection class encapsulates the connection to the Jabber
    # service including managing the socket and controlling the parsing
    # of the Jabber XML stream.
    #
    class Connection 
      DISCONNECTED = 1
      CONNECTED = 2
      
      attr_reader :host, :port, :status, :input, :output
      
      def initialize(host, port=5222)
        @host = host
        @port = port
        @status = DISCONNECTED
        @filters = {}
        @threadBlocks = {}
        @pollCounter = 10
      end
      
      ##
      # Connects to the Jabber server through a TCP Socket and
      # starts the Jabber parser.
      #
      def connect
        @socket = TCPSocket.new(@host, @port)
        @parser = Jabber::Protocol.Parser.new(@socket, self)
        @parserThread = Thread.new {@parser.parse}
        @pollThread = Thread.new {poll}
        @status = CONNECTED
      end
      
      ##
      # Mounts a block to handle exceptions if they occur during the 
      # poll send.  This will likely be the first indication that
      # the socket dropped in a Jabber Session.
      #
      def on_connection_exception(&block)
        @exception_block = block
      end
      
      def parse_failure
        Thread.new {@exception_block.call if @exception_block}
      end
      
      ##
      # Returns if this connection is connected to a Jabber service
      #
      # return:: [Boolean] Connection status
      #
      def is_connected?
        return @status == CONNECTED
      end
      
      ##
      # Returns if this connection is NOT connected to a Jabber service
      #
      # return:: [Boolean] Connection status
      #
      def is_disconnected?
        return @status == DISCONNECTED
      end
      
      ##
      # Processes a received ParsedXMLElement and executes 
      # registered thread blocks and filters against it.
      #
      # element:: [ParsedXMLElement] The received element
      # 
      def receive(element)
        while @threadBlocks.size==0 && @filters.size==0
          sleep 0.1
        end        
        Jabber::DEBUG && puts("RECEIVED:\n#{element.to_s}")
        @threadBlocks.each do |thread, proc|
          begin
            proc.call(element)
            if element.element_consumed?
              @threadBlocks.delete(thread)
              thread.wakeup if thread.alive?
              return
            end
          rescue Exception => error
            puts error.to_s
            puts error.backtrace.join("\n")
          end
        end
        @filters.each_value do |proc|
          begin
            proc.call(element)
            return if element.element_consumed?
          rescue Exception => error
            puts error.to_s
            puts error.backtrace.join("\n")
          end
        end
      end
      
      ##
      # Sends XML data to the socket and (optionally) waits
      # to process received data.
      #
      # xml:: [String] The xml data to send
      # proc:: [Proc = nil] The optional proc
      # &block:: [Block] The optional block
      #
      def send(xml, proc=nil, &block)
        Jabber::DEBUG && puts("SENDING:\n#{ xml.kind_of?(String) ? xml : xml.to_s }")
        xml = xml.to_s if not xml.kind_of? String
        block = proc if proc
        @threadBlocks[Thread.current]=block if block
        begin
          @socket << xml
        rescue
          raise JabberConnectionException.new(true, xml)
        end
        @pollCounter = 10
      end
      
      ##
      # Starts a polling thread to send "keep alive" data to prevent
      # the Jabber connection from closing for inactivity.
      #
      def poll
        sleep 10
        while true
          sleep 2
          @pollCounter = @pollCounter - 1
          if @pollCounter < 0
            begin
              send("  \t  ")
            rescue
              Thread.new {@exception_block.call if @exception_block}
              break
            end
          end
        end
      end
      
      ##
      # Adds a filter block/proc to process received XML messages
      #
      # xml:: [String] The xml data to send
      # proc:: [Proc = nil] The optional proc
      # &block:: [Block] The optional block
      #      
      def add_filter(ref, proc=nil, &block)
        block = proc if proc
        raise "Must supply a block or Proc object to the addFilter method" if block.nil?
        @filters[ref] = block
      end
      
      def delete_filter(ref)
        @filters.delete(ref)
      end
      
      ##
      # Closes the connection to the Jabber service
      #
      def close
        @parserThread.kill if @parserThread
        @pollThread.kill
        @socket.close if @socket
        @status = DISCONNECTED
      end
    end  

    ##
    # Generates an open stream XML element
    #
    # host:: [String] The host being connected to
    # return:: [String] The XML data to send
    #
    def Protocol.gen_open_stream(host)
      return ('<?xml version="1.0" encoding="UTF-8" ?><stream:stream to="'+host+'" xmlns="jabber:client" xmlns:stream="http://etherx.jabber.org/streams">')
    end
    
    ##
    # Generates an close stream XML element
    #
    # return:: [String] The XML data to send
    #
    def Protocol.gen_close_stream
      return "</stream:stream>"
    end
    
    ##
    # The presence class is used to construct presence messages to 
    # send to the Jabber service.
    #
    class Presence
      attr_accessor :to, :from, :id, :type
      
      # The state to show (chat, xa, dnd, away)
      attr_accessor :show
      
      # The status message
      attr_accessor :status
      attr_accessor :priority
      
      ##
      # Constructs a Presence object w/the supplied id
      #
      # id:: [String] The message ID
      # show:: [String] The state to show
      # status:: [String] The status message
      #
      def initialize(id, show=nil, status=nil)
        @id = id
        @show = show if show
        @status = status if status
      end
      
      ##
      # Generate a presence object for initial presence notification
      #
      # id:: [String] The message ID
      # show:: [String] The state to show
      # status:: [String] The status message
      # return:: [Jabber::Protocol::Presence] The newly created Presence object
      #
      def Presence.gen_initial(id, show=nil, status=nil)
        Presence.new(id, show, status)
      end
    
      ##
      # Generate a presence object w/show="normal" (normal availability)
      #
      # id:: [String] The message ID
      # status:: [String=nil] The status message
      # return:: [Jabber::Protocol::Presence] The newly created Presence object
      #
      def Presence.gen_normal(id, status=nil)
        Presence.new(id, "normal", status)
      end
    
      ##
      # Generate a presence object w/show="chat" (free for chat)
      #
      # id:: [String] The message ID
      # status:: [String=nil] The status message
      # return:: [Jabber::Protocol::Presence] The newly created Presence object
      #
      def Presence.gen_chat(id, status=nil)
        Presence.new(id, "chat", status)
      end
    
      ##
      # Generate a presence object w/show="xa" (extended away)
      #
      # id:: [String] The message ID
      # status:: [String=nil] The status message
      # return:: [Jabber::Protocol::Presence] The newly created Presence object
      #
      def Presence.gen_xa(id, status=nil)
        Presence.new(id, "xa", status)
      end
    
      ##
      # Generate a presence object w/show="dnd" (do not disturb)
      #
      # id:: [String] The message ID
      # status:: [String=nil] The status message
      # return:: [Jabber::Protocol::Presence] The newly created Presence object
      #
      def Presence.gen_dnd(id, status=nil)
        Presence.new(id, "dnd", status)
      end
    
      ##
      # Generate a presence object w/show="away" (away from resource)
      #
      # id:: [String] The message ID
      # status:: [String=nil] The status message
      # return:: [Jabber::Protocol::Presence] The newly created Presence object
      #
      def Presence.gen_away(id, status=nil)
        Presence.new(id, "away", status)
      end
    
      ##
      # Generate a presence object w/show="unavailable" (not free for chat)
      #
      # id:: [String] The message ID
      # status:: [String=nil] The status message
      # return:: [Jabber::Protocol::Presence] The newly created Presence object
      #
      def Presence.gen_unavailable(id, status=nil)
        p = Presence.new(id)
        p.type="unavailable"
        p
      end
      
      def Presence.gen_new_subscription(to)
        p = Presence.new(Jabber.gen_random_id)
        p.type = "subscribe"
        p.to = to
        p
      end
      
      def Presence.gen_accept_subscription(id, jid)
        p = Presence.new(id)
        p.type = "subscribed"
        p.to = jid
        p
      end
      
      def Presence.gen_accept_unsubscription(id, jid)
        p = Presence.new(id)
        p.type = "unsubscribed"
        p.to = jid
        p
      end
      
      ##
      # Generates the xml representation of this Presence object
      #
      # return:: [String] The presence XML message to send the Jabber service
      #
      def to_xml
        e = XMLElement.new("presence")
        e.add_attribute("id", @id) if @id
        e.add_attribute("from", @from) if @from
        e.add_attribute("to", @to) if @to
        e.add_attribute("type", @type) if @type
        e.add_child("show").add_data(@show) if @show
        e.add_child("status").add_data(@status) if @status
        e.add_child("priority") if @priority
        e.to_s
      end
      
      ##
      # see _to_xml
      #
      def to_s
        to_xml
      end
    end
    
    ##
    # A class used to build/parse IQ requests/responses
    #
    class Iq
      attr_accessor :session,:to, :from, :id, :type, :xmlns, :data,:error,:errorcode
      ERROR="error"
      GET="get"
      SET="set"
      RESULT="result"
      
      ##
      # Factory to build an IQ object from xml element
      #
      # session:: [Jabber::Session] The Jabber session instance
      # element:: [Jabber::Protocol::ParsedXMLElement] The received XML object
      # return:: [Jabber::Protocol::Iq] The newly created Iq object
      #
      def Iq.from_element(session, element)
        iq = Iq.new(session)
        iq.from = Jabber::JID.new(element.attr_from) if element.attr_from
        iq.to = Jabber::JID.new(element.attr_to) if element.attr_to
        iq.type = element.attr_type
        iq.id = element.attr_id
        iq.session=session
        iq.xmlns=element.query.attr_xmlns
        iq.data=element.query
        return iq
      end
      
      ##
      # Default constructor to build an Iq object
      # session:: [Jabber::Session] The Jabber session instance
      # id:: [String=nil] The (optional) id of the Iq object
      def initialize(session,id=nil)
        @session=session
        @id=id
      end
       
      ##
      # Return an IQ object that uses the jabber:iq:private namespace
      #
      def Iq.get_private(session,id,ename,ns)
        iq=Iq.new(session,id)
        iq.type="get"
        iq.xmlns="jabber:iq:private"
        iq.data=XMLElement.new(ename,{'xmlns' => ns});
        return iq
      end
      
      
      ##
      # Generates an IQ roster request XML element
      #
      # id:: [String] The message id
      # return:: [String] The XML data to send
      #
      def Iq.gen_roster(session, id)
        iq = Iq.new(session, id)
        iq.type = "get"
        iq.xmlns = "jabber:iq:roster"
        return iq
        #return XMLElement.new("iq", {"type"=>"get", "id"=>id}).add_child("query", {"xmlns"=>"jabber:iq:roster"}).to_s
      end
      
      ##
      # Generates an IQ authortization request XML element
      #
      # id:: [String] The message id
      # username:: [String] The username
      # password:: [String] The password
      # email:: [String] The email address of the account
      # name:: [String] The full name
      # return:: [String] The XML data to send
      #
      def Iq.gen_registration(session, id, username, password, email, name)
        iq = Iq.new(session, id)
        iq.type = "set"
        iq.xmlns = "jabber:iq:register"
        iq.data = XMLElement.new("username").add_data(username).to_s 
        iq.data << XMLElement.new("password").add_data(password).to_s
        iq.data << XMLElement.new("email").add_data(email).to_s
        iq.data << XMLElement.new("name").add_data(name).to_s
        return iq
      end
      
      ##
      # Generates an IQ Roster Item add request XML element
      #
      # session:: [Session] The session
      # id:: [String] The message id
      # jid:: [JID] The Jabber ID to add to the roster
      # name:: [String] The full name
      # return:: [String] The XML data to send
      #
      def Iq.gen_add_rosteritem(session, id, jid, name)
        iq = Iq.new(session, id)
        iq.type = "set"
        iq.xmlns = "jabber:iq:roster"
        iq.data = XMLElement.new("item").add_attribute("jid", jid).add_attribute("name", name).to_s
        return iq
      end
      
      ##
      # Generates an IQ authortization request XML element
      #
      # id:: [String] The message id
      # username:: [String] The username
      # password:: [String] The password
      # resource:: [String] The resource to bind this session to
      # return:: [String] The XML data to send
      #
      def Iq.gen_auth(session, id, username, password, resource)
        iq = Iq.new(session, id)
        iq.type = "set"
        iq.xmlns = "jabber:iq:auth"
        iq.data = XMLElement.new("username").add_data(username).to_s 
        iq.data << XMLElement.new("password").add_data(password).to_s
        iq.data << XMLElement.new("resource").add_data(resource).to_s
        return iq
        #element = XMLElement.new("iq", {"type"=>"set", "id"=>id}).add_child("query", {"xmlns"=>"jabber:iq:auth"}).add_child("username").add_data(username).to_parent.add_child("password").add_data(password).to_parent.add_child("resource").add_data(resource).to_parent.to_s
      end
      
      ##
      # Generates an IQ digest authortization request XML element
      #
      # id:: [String] The message id
      # username:: [String] The username
      # digest:: [String] The SHA-1 hash of the sessionid and the password
      # resource:: [String] The resource to bind this session to
      # return:: [String] The XML data to send
      #
      def Iq.gen_auth_digest(session, id, username, digest, resource)
        iq = Iq.new(session, id)
        iq.type = "set"
        iq.xmlns = "jabber:iq:auth"
        iq.data = XMLElement.new("username").add_data(username).to_s 
        iq.data << XMLElement.new("digest").add_data(digest).to_s
        iq.data << XMLElement.new("resource").add_data(resource).to_s
        return iq
        #return XMLElement.new("iq", {"type"=>"set", "id"=>id}).add_child("query", {"xmlns"=>"jabber:iq:auth"}).add_child("username").add_data(username).to_parent.add_child("digest").add_data(digest).to_parent.add_child("resource").add_data(resource).to_parent.to_s
      end
      
      ##
      # Generates an IQ out of bounds XML element
      #
      # to:: [JID] The Jabber ID to send to
      # url:: [String] The data to send
      # desc:: [String=""] The description of the data
      # return:: [String] The XML data to send
      #
      def Iq.gen_oob(session, to, url, desc="")
        iq = Iq.new(session, nil)
        iq.type = "set"
        iq.xmlns = "jabber:iq:oob"
        iq.data = XMLElement.new("url").add_data(url).to_s
        iq.data << XMLElement.new("desc").add_data(desc).to_s
        return iq
        #return XMLElement.new("iq", {"type"=>"set"}).add_child("query", {"xmlns"=>"jabber:iq:oob"}).add_child("url").add_data(url).to_parent.add_child("desc").add_data(data).to_parent.to_s
      end
  
      ##
      # Generates an VCard request XML element
      #
      # id:: [String] The message ID
      # to:: [JID] The jabber id of the account to get the VCard for
      # return:: [String] The XML data to send
      #
      def Iq.gen_vcard(session, id, to)
        iq = Iq.new(session, id)
        iq.xmlns = "vcard-temp"
        iq.type = "get"
        iq.to = to
        return iq
        #return XMLElement.new("iq", {"type"=>"get", "id"=>id, "to"=>to}).add_child("query", {"xmlns"=>"vcard-temp"}).to_s
      end
        
      
      
       
      ##
      # Sends the IQ to the Jabber service for delivery
      # 
      # wait:: [Boolean = false] Wait for reply before return?
      # &block:: [Block] A block to process the message replies
      #
      def send(wait=false, &block)
        if wait
          iq = nil
          blockedThread = Thread.current
          @session.connection.send(self.to_s, block) do |je| 
            if je.element_tag == "iq" and je.attr_id == @id
              je.consume_element
              iq = Iq.from_element(@session, je)
              blockedThread.wakeup
            end
          end
          Thread.stop
          rturn iq
        else
          @session.connection.send(self.to_s, block) if @session
        end
      end
      
      ##
      # Builds a reply to an existing Iq
      #
      # return:: [Jabber::Protocol::Iq] The result Iq
      #
      def reply
        iq = Iq.new(@session,@id)
        iq.to = @from
        iq.id = @id
        iq.type = 'result'
        @is_reply = true
        return iq
      end
     
      ##
      # Generates XML that complies with the Jabber protocol for
      # sending the Iq through the Jabber service.
      #
      # return:: [String] The XML string.
      #
      def to_xml
        elem = XMLElement.new("iq", { "type"=>@type})
        elem.add_attribute("to" ,@to) if @to
        elem.add_attribute("id", @id) if @id
        elem.add_child("query").add_attribute("xmlns",@xmlns).add_data(@data.to_s)
        if @type=="error" then
          e=elem.add_child("error");
          e.add_attribute("code",@errorcode) if @errorcode
          e.add_data(@error) if @error
        end
        return elem.to_s
      end
      
      ##
      # see to_xml
      #
      def to_s
        to_xml
      end
      
    end
    
    class Message
      attr_accessor :to, :from, :id, :type, :body, :xhtml, :subject, :thread, :x, :oobData, :errorcode, :error
      NORMAL = "normal"
      ERROR="error"
      CHAT="chat"
      GROUPCHAT="groupchat"
      HEADLINE="headline"
      
      ##
      # Factory to build a Message from an XMLElement
      #
      # session:: [Jabber::Session] The Jabber session instance
      # element:: [Jabber::Protocol::ParsedXMLElement] The received XML object
      # return:: [Jabber::Protocol::Message] The newly created Message object
      #
      def Message.from_element(session, element)
        message = Message.new(element.attr_to)
        message.from = Jabber::JID.new(element.attr_from) if element.attr_from
        message.type = element.attr_type
        message.id = element.attr_id
        message.thread = element.thread.element_data
        message.body = element.body.element_data
        message.xhtml = element.xhtml.element_data
        message.subject = element.subject.element_data
        message.oobData = element.x.element_data
        message.session=session
        return message
      end
    
      ##
      # Creates a Message
      #
      # to:: [String | Jabber::JID] The jabber id to send this message to (or from)
      # type:: [Integer=NORMAL] The type of message...Message::(NORMAL, CHAT, GROUPCHAT, HEADLINE)
      #
      def initialize(to, type=NORMAL)
        return unless to
        to = Jabber::JID.new(to) if to.kind_of? String
        @to = to if to.kind_of? Jabber::JID
        @type = type
      end
      
      ##
      # Chaining method...sets the body of the message
      #
      # body:: [String] The message body
      # return:: [Jabber::Protocol::Message] The current Message object
      #
      def set_body(body)
        @body = body.gsub(/[&]/, '&amp;').gsub(/[<]/, '&lt;').gsub(/[']/, '&apos;')
        self
      end
      
      ##
      # Chaining method...sets the subject of the message
      #
      # subject:: [String] The message subject
      # return:: [Jabber::Protocol::Message] The current Message object
      #
      def set_subject(subject)
        @subject = subject.gsub(/[&]/, '&amp;').gsub(/[<]/, '&lt;').gsub(/[']/, '&apos;')
        self
      end
      
      ##
      # Chaining method...sets the XHTML body of the message
      #
      # body:: [String] The message body
      # return:: [Jabber::Protocol::Message] The current message object
      #
      def set_xhtml(xhtml)
        @xhtml=xhtml
        self
      end
       
      ##
      # Chaining method...sets the thread of the message
      #
      # thread:: [String] The message thread id
      # return:: [Jabber::Protocol::Message] The current Message object
      #
      def set_thread(thread)
        @thread = thread
        self
      end
      
      ##
      # Chaining method...sets the OOB data of the message
      #
      # data:: [String] The message OOB data
      # return:: [Jabber::Protocol::Message] The current Message object
      #
      def set_outofband(data)
        @oobData = data
        self
      end
      
      ##
      # Chaining method...sets the extended data of the message
      #
      # x:: [String] The message x data
      # return:: [Jabber::Protocol::Message] The current Message object
      #
      def set_x(x)
        @x = x
        self
      end
      
      ##
      # Sets an error code to be returned(chaining method)
      #
      # code:: [Integer] the jabber error code
      # reason:: [String] Why the error was reported
      # return:: [Jabber::Protocol::Message] The current Message object
      #
      
      def set_error(code,reason)
       @errorcode=code
       @error=reason
       @type="error"
       self
      end
      
      ##
      # Convenience method for send(true)
      #
      # ttl:: [Integer = nil] The time (in seconds) to wait for a reply before assuming nil
      # &block:: [Block] A block to process the message replies
      #
      def request(ttl=nil, &block)
        send(true, ttl, &block)
      end
      
      ##
      # Sends the message to the Jabber service for delivery
      # 
      # wait:: [Boolean = false] Wait for reply before return?
      # ttl:: [Integer = nil] The time (in seconds) to wait for a reply before assuming nil
      # &block:: [Block] A block to process the message replies
      #
      def send(wait=false, ttl=nil, &block)
        if wait
          message = nil
          blockedThread = Thread.current
          timer_thread = nil
          timeout = false
          unless ttl.nil?
            timer_thread = Thread.new {
              sleep ttl
              timeout = true
              blockedThread.wakeup
            }
          end
          @session.connection.send(self.to_s, block) do |je| 
            if je.element_tag == "message" and je.thread.element_data == @thread
              je.consume_element
              message = Message.from_element(@session, je)
              blockedThread.wakeup unless timeout
              unless timer_thread.nil?
                timer_thread.kill
                timer_thread = nil
              end
            end
          end
          Thread.stop
          return message
        else
          @session.connection.send(self.to_s, block) if @session
        end
      end
      
      ##
      # Sets the session instance
      #
      # session:: [Jabber::Session] The session instance
      # return:: [Jabber::Protocol::Message] The current Message object
      #
      def session=(session)
        @session = session
        self
      end
      
      ##
      # Builds a reply to an existing message by setting:
      # 1. to = from
      # 2. id = id
      # 3. thread = thread
      # 4. type = type
      # 5. session = session
      #
      # return:: [Jabber::Protocol::Message] The reply message
      #
      def reply
        message = Message.new(nil)
        message.to = @from
        message.id = @id
        message.thread = @thread
        message.type = @type
        message.session = @session
        @is_reply = true
        return message
      end
      
      ##
      # Generates XML that complies with the Jabber protocol for
      # sending the message through the Jabber service.
      #
      # return:: [String] The XML string.
      #
      def to_xml
        @thread = Jabber.gen_random_thread if @thread.nil? and (not @is_reply)
        elem = XMLElement.new("message", {"to"=>@to, "type"=>@type})
        elem.add_attribute("id", @id) if @id
        elem.add_child("thread").add_data(@thread) if @thread
        elem.add_child("subject").add_data(@subject) if @subject
        elem.add_child("body").add_data(@body) if @body
        if @xhtml then
          t=elem.add_child("xhtml").add_attribute("xmlns","http://www.w3.org/1999/xhtml")
          t.add_child("body").add_data(@xhtml)
        end
        if @type=="error" then
          e=elem.add_child("error");
          e.add_attribute("code",@errorcode) if @errorcode
          e.add_data(@error) if @error
        end
        elem.add_child("x").add_attribute("xmlns", "jabber:x:oob").add_data(@oobData) if @oobData
        elem.add_xml(@x.to_s) if @x
        return elem.to_s
      end
      
      ##
      # see to_xml
      #
      def to_s
        to_xml
      end
      
    end
    
    ##
    # Utility class to create valid XML strings
    #
    class XMLElement
    
      # The parent XMLElement
      attr_accessor :parent
      
      ##
      # Construct an XMLElement for the supplied tag and attributes
      #
      # tag:: [String] XML tag
      # attributes:: [Hash = {}] The attribute hash[attribute]=value
      def initialize(tag, attributes={})
        @tag = tag
        @elements = []
        @attributes = attributes
        @data = ""
      end
      
      ##
      # Adds an attribute to this element
      #
      # attrib:: [String] The attribute name
      # value:: [String] The attribute value
      # return:: [Jabber::Protocol::XMLElement] self for chaining
      #
      def add_attribute(attrib, value)
        @attributes[attrib]=value
        self
      end
      
      ##
      # Adds data to this element
      #
      # data:: [String] The data to add
      # return:: [Jabber::Protocol::XMLElement] self for chaining
      #
      def add_data(data)
        @data += data.to_s
        self
      end
      
      ##
      # Sets the namespace for this tag
      #
      # ns:: [String] The namespace
      # return:: [Jabber::Protocol::XMLElement] self for chaining
      #
      def set_namespace(ns)
        @tag+=":#{ns}"
        self
      end
      
      ##
      # Adds cdata to this element
      #
      # cdata:: [String] The cdata to add
      # return:: [Jabber::Protocol::XMLElement] self for chaining
      #
      def add_cdata(cdata)
        @data += "<![CDATA[#{cdata.to_s}]]>"
        self
      end
      
      ##
      # Returns the parent element
      # 
      # return:: [Jabber::Protocol::XMLElement] The parent XMLElement
      #
      def to_parent
        @parent
      end
      
      ##
      # Adds a child to this element of the supplied tag
      #
      # tag:: [String] The element tag
      # attributes:: [Hash = {}] The attributes hash[attribute]=value
      # return:: [Jabber::Protocol::XMLElement] newly created child element
      #
      def add_child(tag, attributes={})
        child = XMLElement.new(tag, attributes)
        child.parent = self
        @elements << child
        return child
      end
      
      ##
      # Adds arbitrary XML data to this object
      #
      # xml:: [String] the xml to add
      #
      def add_xml(xml)
        @xml = xml
      end
      
      ##
      # Recursively builds the XML string by traversing this element's
      # children.
      #
      # format:: [Boolean] True to pretty-print (format) the output string
      # indent:: [Integer = 0] The indent level (recursively more)
      #
      def to_xml(format, indent=0)
        result = ""
        result += " "*indent if format
        result += "<#{@tag}"
        @attributes.each {|attrib, value| result += (' '+attrib.to_s+'="'+value.to_s+'"') }
        if @data=="" and @elements.size==0
          result +="/>"
          result +="\n" if format
          return result
        end
        result += ">"
        result += "\n" if format and @data==""
        result += @data if @data!=""
        @elements.each {|element| result+=element.to_xml(format, indent+4)}
        result += @xml if not @xml.nil?
        result += " "*indent if format and @data==""
        result+="</#{@tag}>"
        result+="\n" if format
        return result
      end
      
      ##
      # Climbs to the top of this elements parent tree and then returns
      # the to_xml XML string.
      #
      # return:: [String] The XML string of this element (from the topmost parent).
      #
      def to_s
        return @parent.to_s if @parent
        return to_xml(true)
      end
    end
    
    ##
    # This class is constructed from XML data elements that are received from
    # the Jabber service.
    #
    class ParsedXMLElement  
      
      ##
      # This class is used to return nil element values to prevent errors (and
      # reduce the number of checks.
      #
      class NilParsedXMLElement
      
        ##
        # Override to return nil
        #
        # return:: [nil]
        #
        def method_missing(methId, *args)
          return nil
        end
        
        ##
        # Evaluate as nil
        #
        # return:: [Boolean] true
        #
        def nil?
          return true
        end
        
        ##
        # Return a zero count
        #
        # return:: [Integer] 0
        #
        def count
          0
        end
        
        include Singleton
      end
      
      # The <tag> as String
      attr_reader :element_tag
      
      # The parent ParsedXMLElement
      attr_reader :element_parent
      
      # A hash of ParsedXMLElement children
      attr_reader :element_children
      
      # The data <tag>data</tag> for a tag
      attr_reader :element_data
      
      ##
      # Construct an instance for the given tag
      #
      # tag:: [String] The tag
      # parent:: [Jabber::Protocol::ParsedXMLElement = nil] The parent element
      #
      def initialize(tag, parent=nil)
        @element_tag = tag
        @element_parent = parent
        @element_children = {}
        @attributes = {}
        @element_consumed = false
      end
      
      ##
      # Add the attribute to the element
      #   <tag name="value">data</tag>
      # 
      # name:: [String] The attribute name
      # value:: [String] The attribute value
      # return:: [Jabber::Protocol::ParsedXMLElement] self for chaining
      #
      def add_attribute(name, value)
        @attributes[name]=value
        self
      end
      
      ##
      # Factory to build a child element from this element with the given tag
      #
      # tag:: [String] The tag name
      # return:: [Jabber::Protocol::ParsedXMLElement] The newly created child element
      #
      def add_child(tag)
        child = ParsedXMLElement.new(tag, self)
        @element_children[tag] = Array.new if not @element_children.has_key? tag
        @element_children[tag] << child
        return child
      end
      
      ##
      # When an xml is received from the Jabber service and a ParsedXMLElement is created,
      # it is propogated to all filters and listeners.  Any one of those can consume the element 
      # to prevent its propogation to other filters or listeners. This method marks the element
      # as consumed.
      #
      def consume_element
        @element_consumed = true
      end
      
      ##
      # Checks if the element is consumed
      #
      # return:: [Boolean] True if the element is consumed
      #
      def element_consumed?
        @element_consumed
      end
      
      ##
      # Appends data to the element
      #
      # data:: [String] The data to append
      # return:: [Jabber::Protocol::ParsedXMLElement] self for chaining
      #
      def append_data(data)
        @element_data = "" unless @element_data
        @element_data += data
        self
      end
      
      ##
      # Calls the parent's element_children (hash) index off of this elements
      # tag and gets the supplied index.  In this sense it gets its sibling based
      # on offset.
      #
      # number:: [Integer] The number of the sibling to get
      # return:: [Jabber::Protocol::ParsedXMLElement] The sibling element
      #
      def [](number)
        return @element_parent.element_children[@element_tag][number] if @element_parent
      end
      
      ##
      # Returns the count of siblings with this element's tag
      #
      # return:: [Integer] The number of sibling elements
      #
      def count
        return @element_parent.element_children[@element_tag].size if @element_parent
        return 0
      end
      
      ##
      # see _count
      #
      def size
        count
      end
      
      ##
      # Overrides to allow for directly accessing child elements
      # and attributes.  If prefaced by attr_ it looks for an attribute
      # that matches or checks for a child with a tag that matches
      # the method name.  If no match occurs, it returns a 
      # NilParsedXMLElement (singleton) instance.
      # 
      # Example:: <alpha number="1"><beta number="2">Beta Data</beta></alpha>
      #
      #  element.element_tag #=> alpha
      #  element.attr_number #=> 1
      #  element.beta.element_data #=> Beta Data
      #
      def method_missing(methId, *args)
          tag = methId.id2name
          if tag[0..4]=="attr_"
            return @attributes[tag[5..-1]]
          end
          list = @element_children[tag]
          return list[0] if list
          return NilParsedXMLElement.instance
      end  
      
      ##
      # Returns the valid XML as a string
      #
      # return:: [String] XML string
      def to_s
        begin
          result = "\n<#{@element_tag}"
          @attributes.each {|key, value| result += (' '+key+'="'+value+'"') }
          if @element_children.size>0 or @element_data
            result += ">"
          else
            result += "/>" 
          end
          result += @element_data if @element_data
          @element_children.each_value {|array| array.each {|je| result += je.to_s} }
          result += "\n" if @element_children.size>0
          result += "</#{@element_tag}>" if @element_children.size>0 or @element_data
          result
        rescue => exception
          puts exception.to_s
        end
      end
    end
    
    if USE_PARSER == :xmlparser
      require 'xmlparser'
      ##
      # The ExpatJabberParser uses XMLParser (expat) to parse the incoming XML stream
      # of the Jabber protocol and fires ParsedXMLElements at the Connection
      # instance.
      #
      class ExpatJabberParser
        
        # status if the parser is started
        attr_reader :started
        
        ##
        # Constructs a parser for the supplied stream (socket input)
        #
        # stream:: [IO] Socket input stream
        # listener:: [#receive(ParsedXMLElement)] The listener (usually a Jabber::Protocol::Connection instance
        #
        def initialize(stream, listener)
          @stream = stream
          def @stream.gets
            super(">")
          end
          @listener = listener
        end
        
        ##
        # Begins parsing the XML stream and does not return until
        # the stream closes.
        #
        def parse
          @started = false
  
          parser = XMLParser.new("UTF-8")
          def parser.unknownEncoding(e)
            raise "Unknown encoding #{e.to_s}"
          end
          def parser.default
          end
          
          begin
            parser.parse(@stream) do |type, name, data|
              begin
              case type
                when XMLParser::START_ELEM
                  case name
                    when "stream:stream"
                      openstream = ParsedXMLElement.new(name)
                      data.each {|key, value| openstream.add_attribute(key, value)}
                      @listener.receive(openstream)
                      @started = true
                    else 
                      if @current.nil?
                        @current = ParsedXMLElement.new(name.clone)
                      else
                        @current = @current.add_child(name.clone)
                      end
                      data.each {|key, value| @current.add_attribute(key.clone, value.clone)}
                  end
                when XMLParser::CDATA
                  @current.append_data(data.clone) if @current
                when XMLParser::END_ELEM
                  case name
                    when "stream:stream"
                      @started = false
                    else
                      @listener.receive(@current) unless @current.element_parent
                      @current = @current.element_parent
                  end
              end
              rescue
                puts  "Error #{$!}"
              end
            end
          rescue XMLParserError
            line = parser.line
            print "XML Parsing error(#{line}): #{$!}\n"
          end
        end
      end
    else # USE REXML
      require 'rexml/document'
      require 'rexml/parsers/sax2parser'
      require 'rexml/source'
      
      ##
      # The REXMLJabberParser uses REXML to parse the incoming XML stream
      # of the Jabber protocol and fires ParsedXMLElements at the Connection
      # instance.
      #
      class REXMLJabberParser
        # status if the parser is started
        attr_reader :started
        
        ##
        # Constructs a parser for the supplied stream (socket input)
        #
        # stream:: [IO] Socket input stream
        # listener:: [Object.receive(ParsedXMLElement)] The listener (usually a Jabber::Protocol::Connection instance
        #
        def initialize(stream, listener)
          @stream = stream
          
          # this hack fixes REXML version "2.7.3" and "2.7.4"
          if REXML::Version=="2.7.3" || REXML::Version=="2.7.4"
            def @stream.read(len=nil)
              len = 100 unless len
              super(len)
            end
            def @stream.gets(char=nil)
              super(">")
            end
            def @stream.readline(char=nil)
              super(">")
            end
            def @stream.readlines(char=nil)
              super(">")
            end
          end
          
          @listener = listener
          @current = nil
        end

        ##
        # Begins parsing the XML stream and does not return until
        # the stream closes.
        #
        def parse
          @started = false
          begin
            parser = REXML::Parsers::SAX2Parser.new @stream 
            parser.listen( :start_element ) do |uri, localname, qname, attributes|
              case qname
              when "stream:stream"
                openstream = ParsedXMLElement.new(qname)
                attributes.each { |attr, value| openstream.add_attribute(attr, value) }              
                @listener.receive(openstream)
                @started = true
              else 
                if @current.nil?
                  @current = ParsedXMLElement.new(qname)
                else
                  @current = @current.add_child(qname)
                end
                attributes.each { |attr, value| @current.add_attribute(attr, value) }
              end
            end
            parser.listen( :end_element ) do  |uri, localname, qname|
              case qname
              when "stream:stream"
                @started = false
              else
                @listener.receive(@current) unless @current.element_parent
                @current = @current.element_parent
              end
            end
            parser.listen( :characters ) do | text |
              @current.append_data(text) if @current
            end
            parser.listen( :cdata ) do | text |
              @current.append_data(text) if @current
            end
            parser.parse
          rescue REXML::ParseException
            @listener.parse_failure
          end
        end
      end
    end # USE_PARSER
  end 
end

