module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:positive_vote, :negative_vote, :re_vote]
    before_action :author_votable_vote, only: [:positive_vote, :negative_vote]
    before_action :author_votable_re_vote, only: [:re_vote]
  end

  def positive_vote
    if @votable.user_vote?(current_user)
      @votable.positive(current_user)
      render json: { id: @votable.id, rating: @votable.rating }
    else
      render json: { id: @votable.id, message: 'You can vote once' }, status: :unprocessable_entity
    end
  end

  def negative_vote
    if @votable.user_vote?(current_user)
      @votable.negative(current_user)
      render json: { id: @votable.id, rating: @votable.rating }
    else
      render json: { id: @votable.id, message: 'You can vote once' }, status: :unprocessable_entity
    end
  end

  def re_vote
    if @votable.user_vote?(current_user)
      render json: { id: @votable.id, message: 'You must vote' }, status: :unprocessable_entity
    else
      @votable.re_vote(current_user)
      render json: { id: @votable.id, rating: @votable.rating }
    end
  end

  private

  def author_votable_vote
    if !current_user || current_user.author?(@votable)
      render json: { id: @votable.id, message: 'You can\'t vote' }, status: :unprocessable_entity
    end
  end

  def author_votable_re_vote
    if !current_user || current_user.author?(@votable)
      render json: { id: @votable.id, message: 'You can\'t re-vote' }, status: :unprocessable_entity
    end
  end

  def load_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end