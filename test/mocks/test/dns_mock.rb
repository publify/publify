class IPSocket
  def self.getaddress(host)
    if %w{
      buy-computer.us.bsb.empty.us
      chinaaircatering.com.bsb.empty.us
      206.230.42.212.opm.blitzed.us
    }.include?(host)
      "127.0.0.2"
    else
      raise SocketError.new("getaddrinfo: Name or service not known")
    end
  end
end
