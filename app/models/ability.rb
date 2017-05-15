class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    alias_action :positive_vote, :negative_vote, :re_vote, to: :vote

    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Attachment]
    can [:update, :destroy], [Question, Answer, Comment], user: @user
    can :destroy, Attachment, attachmentable: { user: @user }
    can :set_best, [Answer]{ |answer| user.author?(answer.question) }
    can :vote, [Question, Answer] { |votable| !@user.author?(votable) }
  end
end
