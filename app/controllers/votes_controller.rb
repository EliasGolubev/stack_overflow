class VotesController < ApplicationController
  before_action :authenticate_user!
  def create
    @question = Question.find(params[:question_id])
    if @question.user_id != current_user.id
      @vote = @question.votes.build(votes_params)
      @vote.user_id = current_user.id
      @vote.save
    end
  end

  def update
    @vote = Vote.find(params[:id])
    if @vote.user_id == current_user.id
      @vote.update(votes_params)
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    if @vote.user_id == current_user.id
      @vote.destroy
    end
  end

  private

  def votes_params
    params.require(:vote).permit(:vote)
  end
end