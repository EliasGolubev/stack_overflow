require 'active_support/concern'

module Votable
  extend ActiveSupport::Concern

  POSITIVE_VALUE = 1
  NEGATIVE_VALUE = -1

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.sum(:user_vote)
  end

  def positive(user)
    votes.create(user: user, user_vote: POSITIVE_VALUE)
  end

  def negative(user)
    votes.create(user: user, user_vote: NEGATIVE_VALUE)
  end

  def user_vote?(user)
    votes.where(user: user).empty?
  end

  def re_vote(user)
    votes.where(user: user).destroy_all
  end
end
