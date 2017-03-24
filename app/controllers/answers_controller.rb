class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :load_answer, only: [:update, :destroy]
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.id == @answer.user_id
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.id == @answer.user_id
    redirect_to @question
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end


  def answer_params
    params.require(:answer).permit(:body)
  end
end
