class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :delete]
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      #redirect_to @question
    else
      render "questions/show"
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @answer.destroy if current_user.id == @answer.user_id
    redirect_to @question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
