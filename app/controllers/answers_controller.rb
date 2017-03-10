class AnswersController < ApplicationController
  before_action :load_answer,   only: [:edit, :update, :destroy]

  def new 
    @answer = Answer.new
  end

  def edit; end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question
    else
      render :edit
    end
  end

  def destroy
    @question = @answer.question
    @answer.destroy
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
