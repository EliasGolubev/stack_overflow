class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vote, only: [:update, :destroy]
  def create
    @question = Question.find(params[:question_id])
    if !current_user.author?(@question)
      @vote = @question.votes.build(votes_params)
      @vote.user_id = current_user.id
      @vote.save
    end
  end

  def update
    @vote.update(votes_params) if current_user.author?(@vote)
  end

  def destroy
    @vote.destroy if current_user.author?(@vote)
  end

  private

  def set_vote
    @vote = Vote.find(params[:id])
  end

  def votes_params
    params.require(:vote).permit(:vote)
  end
end