class Ability
  include CanCan::Ability

  def initialize(user)
    Rails.logger.info "Initializing Ability for user: #{user.inspect}"
    user ||= User.new # Ensure a user object is always present
    Rails.logger.info "User Role: #{user.role.inspect}"

    alias_action :create, :read, :update, :destroy, to: :crud

    case user.role
    when 'super_user'
      can :manage, :all
    when 'manager'
      can :create, User, country_id: user.country_id
      can :read, Property, country_id: user.country_id
      can :update, Property, country_id: user.country_id # Approve properties
      # can :read, FinancialRecord, country_id: user.country_id
    when 'employee'
      # Assign permissions based on the employee category
      can :update, Property
      # if user.category == 'property_reviewer'
      #   can :update, Property, state: ['active', 'inactive'], country_id: user.country_id
      # elsif user.category == 'accountant'
      #   can :read, FinancialRecord, country_id: user.country_id
      # end
    end
  end

  def can_assign_role?(user, role_to_assign)
    case user.role
    when 'super_user'
      true # Super users can assign any role.
    when 'manager'
      ['manager', 'employee'].include?(role_to_assign) # Limit roles managers can assign.
    else
      false # Other roles cannot assign roles.
    end
  end
end
