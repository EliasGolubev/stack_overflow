class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:create, :update, :destroy, :set_best]
  before_action :load_answer, only: [:update, :destroy, :set_best]
  before_action :load_question, only: [:create]

  after_action :destroy_answer, only: [:destroy]
  after_action :publish_answer, only: [:create] 

  respond_to :js

  authorize_resource

  def create
    respond_with @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def update
    respond_with @answer.update(answer_params) if current_user.author?(@answer)
  end

  def destroy
    respond_with @answer.destroy if current_user.author?(@answer)
  end

  def set_best
    respond_with @answer.set_best if !@answer.best? && current_user.author?(@answer.question)
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def publish_answer
      return if @answer.errors.any?

      ActionCable.server.broadcast("/questions/#{@question.id}/answers", 
        answer: @answer,
        rating: @answer.rating,
        attachments: @answer.attachments.as_json(methods: :with_meta),
        question_user_id: @question.user_id,
        method: 'publish')
  end

  def destroy_answer
    return if !current_user.author?(@answer)
    ActionCable.server.broadcast("/questions/#{@answer.question_id}/answers",
      answer_id: @answer.id,
      method: 'delete')
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
