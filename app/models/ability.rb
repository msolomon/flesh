# https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
      can :read, ActiveAdmin::Page, name: "Dashboard"
    else
      can :read, Organization
      can :read, Game
    end

  end

end
