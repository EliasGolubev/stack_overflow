module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:positive_vote, :negative_vote, :re_vote]
  end

  def positive_vote
    if @votable.user_vote?(current_user)
      if !current_user || current_user.id == @votable.user_id
        render json: { id: @votable.id, message: 'You can\'t vote' }, status: :unprocessable_entity
      else
        @votable.positive(current_user)
        render json: { id: @votable.id, rating: @votable.rating }
      end
    else
      render json: { id: @votable.id, message: 'You can vote once' }, status: :unprocessable_entity
    end
  end

  def negative_vote
    if @votable.user_vote?(current_user)
      if !current_user || current_user.id == @votable.user_id
        render json: {id: @votable.id, message: 'You can\'t vote' }, status: :unprocessable_entity
      else
        @votable.negative(current_user)
        render json: { id: @votable.id, rating: @votable.rating }
      end
    else
      render json: { id: @votable.id, message: 'You can vote once' }, status: :unprocessable_entity
    end
  end

  def re_vote
    if !current_user || current_user.id == @votable.user_id
      render json: { id: @votable.id, message: 'You can\'t re-vote' }, status: :unprocessable_entity
    else
      if @votable.user_vote?(current_user)
        render json: { id: @votable.id, message: 'You must vote' }, status: :unprocessable_entity
      else
        @votable.re_vote(current_user)
        render json: { id: @votable.id, rating: @votable.rating }
      end
    end
  end

  private

  def load_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end