require 'uuidtools'

module PublifyGuid
  def create_guid
    return true if guid.present?

    self.guid = UUIDTools::UUID.random_create.to_s
  end
end
