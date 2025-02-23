class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?
    return unless user.admin?

    can :manage, :all
  end
end
