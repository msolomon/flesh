# https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :read, ActiveAdmin::Page, name: "Dashboard"

    if user.admin?
      can :manage, :all
    end

  end

end
