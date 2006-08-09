require 'jabber4r/jabber4r'

class JabberNotify
  @@jabber = nil

  def self.logger
    @@logger ||= RAILS_DEFAULT_LOGGER || Logger.new(STDOUT)
  end

  def self.send_message(user, subject, body, html)
    return if user.jabber.blank?

    begin
      STDERR.puts "** Sending #{body} to #{user.jabber} via jabber."
      message = session.new_message(user.jabber)
      message.subject = subject
      message.body = body
      message.xhtml = html
      message.send
    rescue => err
      logger.error "Attempt to use jabber failed: #{err.inspect}" if logger
    end
  end

  private
  def self.session
    return @@jabber if @@jabber

    address = Blog.default.jabber_address
    unless address =~ /\//
      address = address + '/typo'
    end

    @@jabber ||= Jabber::Session.bind(address, Blog.default.jabber_password)
  end
end
