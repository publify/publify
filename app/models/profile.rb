class Profile < ActiveRecord::Base
  serialize :modules
  validates :label, uniqueness: true

  ADMIN = 'admin'.freeze
  PUBLISHER = 'publisher'.freeze
  CONTRIBUTOR = 'contributor'.freeze

  def modules
    self[:modules] || []
  end

  def modules=(perms)
    perms = perms.map { |p| p.to_sym unless p.blank? }.compact if perms
    self[:modules] = perms
  end
end
