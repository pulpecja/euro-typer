class Ability
  include CanCan::Ability

  def initialize(user, namespace = nil)
    user ||= User.new
    case namespace
      when 'Admin'
        can :manage, :all if user.is_admin?
      else
        if user.is_admin?
          can :manage, :all
        elsif user.is_registered?
          can :read, [Competition, Match, Page, Team, User, Type]
          can %i[read create join], Group
          can %i[update destroy], Group, owner_id: user.id
          can %i[create update destroy], Type, user_id: user.id
          can :create, WinnerType
          can %i[read update destroy], WinnerType, user_id: user.id
        end
      end
  end
end
