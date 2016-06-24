require 'cancancan'

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    case user.profile
    when 'admin'
      add_admin_abilities
      add_publisher_abilities
      add_contributor_abilities
    when 'publisher'
      add_publisher_abilities
      add_contributor_abilities
    when 'contributor'
      add_contributor_abilities
    end
  end

  private

  def add_admin_abilities
    can :manage, 'admin/cache'
    can :manage, 'admin/migrations'
    can :manage, 'admin/seo'
    can :manage, 'admin/settings'
    can :manage, 'admin/sidebar'
    can :manage, 'admin/textfilters'
    can :manage, 'admin/themes'
    can :manage, 'admin/users'
  end

  def add_publisher_abilities
    can :manage, 'admin/content'
    can :manage, 'admin/feedback'
    can :manage, 'admin/notes'
    can :manage, 'admin/pages'
    can :manage, 'admin/post_types'
    can :manage, 'admin/redirects'
    can :manage, 'admin/resources'
    can :manage, 'admin/tags'

    can :manage, 'articles'
  end

  def add_contributor_abilities
    can :manage, 'admin/dashboard'
    can :manage, 'admin/profiles'
  end
end
