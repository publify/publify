class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    allowed_controllers = AccessControl.allowed_controllers(user.profile.label, user.profile.modules)
    allowed_controllers.each do |controller_name|
      can :manage, controller_name
    end

    can :manage, "admin/cache"
    can :manage, "admin/dashboard"
    can :manage, "admin/textfilters"
    can :manage, "admin/profiles"
    can :manage, "admin/migrations"

    can :manage, "articles"
  end
end
