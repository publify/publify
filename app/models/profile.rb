class Profile < ActiveRecord::Base
  serialize :modules
  validates :label, uniqueness: true

  ADMIN = 'admin'
  PUBLISHER = 'publisher'
  CONTRIBUTOR = 'contributor'

  def modules
    self[:modules] || []
  end

  def modules=(perms)
    perms = perms.map { |p| p.to_sym unless p.blank? }.compact if perms
    self[:modules] = perms
  end

  def project_modules
    modules.map do |mod|
      AccessControl.project_module(label, mod)
    end.uniq.compact
  end
end
