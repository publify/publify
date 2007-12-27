require 'xmpp4r/client'

class JabberNotify
  @@jabber = nil

  def self.logger
    @@logger ||= RAILS_DEFAULT_LOGGER || Logger.new(STDOUT)
  end

  def self.send_message(user, subject, body, html)
    return if user.jabber.blank?

    begin
      STDERR.puts "** Sending #{body} to #{user.jabber} via jabber."
      message = Jabber::Message::new(user.jabber, body)
      message.subject = subject
      session.send(message)
    rescue => err
      logger.error "Attempt to use jabber failed: #{err.inspect}" if defined? logger 
    end
  end

  private
  def self.session
    return @@jabber if @@jabber

    address = Blog.default.jabber_address
    unless address =~ /\//
      address = address + '/typo'
    end

    @@jabber = Jabber::Client.new(Jabber::JID.new(address), true) 
    @@jabber.connect 
    @@jabber.auth(Blog.default.jabber_password) 
    return @@jabber    
  end
end
