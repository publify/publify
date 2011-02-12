module TypoGuid
  def create_guid
    self.guid rescue return true
    return true unless self.guid.blank?

    self.guid = UUIDTools::UUID.random_create.to_s
  end
end
