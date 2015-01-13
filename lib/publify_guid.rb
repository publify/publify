module PublifyGuid
  def create_guid
    guid rescue return true
    return true unless guid.blank?

    self.guid = UUIDTools::UUID.random_create.to_s
  end
end
