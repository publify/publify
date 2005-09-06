require 'md5'

module TypoGuid
  def create_guid
    self.guid rescue return true
    return true unless self.guid.blank?
    
    guid_text = self.inspect+Time.now.to_f.to_s
    begin
      guid_text += File.open("/dev/urandom",'r').read(16)
    rescue => err
    end
    self.guid = Digest::MD5.new(guid_text).to_s
    true
  end
end
