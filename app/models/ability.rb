class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    allowed_controllers = AccessControl.allowed_controllers(user.profile.label, user.profile.modules)
    allowed_controllers.each do |controller_name|
      can :manage, controller_name
    end
  end
end
