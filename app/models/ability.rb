class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.is_admin?
      can :manage, :all
    elsif user.is_registered?
      can :read, Page
      can :read, Match
      can :read, Group
      can :read, Competition
      can :manage, Type
      can :create, Group
      can [:update, :destroy], Group, owner_id: user.id
    end
  end
end
