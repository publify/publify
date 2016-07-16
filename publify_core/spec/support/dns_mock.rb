class IPSocket
  def self.getaddress(host)
    case host
    when 'buy-computer.us.bsb.empty.us', 'chinaaircatering.com.bsb.empty.us',
      '206.230.42.212.opm.blitzed.us', '207.230.42.212.opm.blitzed.us'
      '127.0.0.2'
    when 'bofh.org.uk.multi.surbl.org', 'www.bofh.org.uk.multi.surbl.org'
      '10.10.10.10'
    else
      raise SocketError, 'getaddrinfo: Name or service not known'
    end
  end
end
