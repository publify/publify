class IPSocket
  def self.getaddress(host)
    if %w{
      buy-computer.us.bsb.empty.us
      chinaaircatering.com.bsb.empty.us
      212.42.230.206.opm.blitzed.us
    }.include?(host)
      "127.0.0.2"
    else
      "10.10.10.10"
    end
  end
end