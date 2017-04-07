class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy, :set_best]
  before_action :load_answer, only: [:update, :destroy, :set_best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    @answer.save
    #respond_to do |format|
    #  if @answer.save
    #    format.js
    #    format.html { render partial: @answer, layout: false }
    #    format.json { render json: @answer }
    #  else
    #    format.js
    #    format.html { render text: @answer.errors.full_messages.join("\n"), status: :unprocessable_entity }
    #    format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
    #  end
    #end
  end

  def update
    @answer.update(answer_params) if current_user.id == @answer.user_id
  end

  def destroy
    @answer.destroy if current_user.id == @answer.user_id
  end

  def set_best
    @answer.set_best if !@answer.best? && @answer.question.user_id == current_user.id
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
