class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role == 'super_user'
      can :manage, :all
    elsif user.role == 'manager'
      can :manage, [User, Property]
    elsif user.role == 'employee'
      can :read, Property
    end
  end
end