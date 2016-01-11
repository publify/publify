class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    case user.profile.label
    when 'admin'
      can :manage, 'admin/cache'
      can :manage, 'admin/content'
      can :manage, 'admin/feedback'
      can :manage, 'admin/notes'
      can :manage, 'admin/pages'
      can :manage, 'admin/post_types'
      can :manage, 'admin/redirects'
      can :manage, 'admin/resources'
      can :manage, 'admin/seo'
      can :manage, 'admin/settings'
      can :manage, 'admin/sidebar'
      can :manage, 'admin/tags'
      can :manage, 'admin/themes'
      can :manage, 'admin/users'
    when 'publisher'
      can :manage, 'admin/content'
      can :manage, 'admin/feedback'
      can :manage, 'admin/notes'
      can :manage, 'admin/pages'
      can :manage, 'admin/post_types'
      can :manage, 'admin/redirects'
      can :manage, 'admin/resources'
      can :manage, 'admin/tags'
    when 'contributor'
    end

    # TODO: Limit these!
    can :manage, 'admin/cache'
    can :manage, 'admin/dashboard'
    can :manage, 'admin/textfilters'
    can :manage, 'admin/profiles'
    can :manage, 'admin/migrations'

    can :manage, 'articles'
  end
end
