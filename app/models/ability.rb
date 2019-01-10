class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.is_admin?
      can :manage, :all
    elsif user.is_registered?
      can :manage, Type
      can :read, [Competition, Match, Page, Team, User]
      can [:read, :create], Group
      can [:update, :destroy], Group, owner_id: user.id
      can :create, WinnerType
      can :update, WinnerType, user_id: user.id
    end
  end
end
