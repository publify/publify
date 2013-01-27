class Profile < ActiveRecord::Base
  serialize :modules
  validates_uniqueness_of :label

  ADMIN = 'admin'
  PUBLISHER = 'publisher'
  CONTRIBUTOR = 'contributor'

  def modules
    read_attribute(:modules) || []
  end

  def modules=(perms)
    perms = perms.collect {|p| p.to_sym unless p.blank? }.compact if perms
    write_attribute(:modules, perms)
  end

  def project_modules
    modules.collect { |mod|
      AccessControl.project_module(label, mod) }.uniq.compact
  end
end
