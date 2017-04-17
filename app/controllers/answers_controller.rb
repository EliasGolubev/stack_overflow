class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:create, :update, :destroy, :set_best]
  before_action :load_answer, only: [:update, :destroy, :set_best]
  before_action :destroy_answer, only: [:destroy]

  after_action :publish_answer, only: [:create] 

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
  end

  def set_best
    @answer.set_best if !@answer.best? && current_user.author?(@answer.question)
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def publish_answer
      return if @answer.errors.any?

      ActionCable.server.broadcast("/questions/#{@question.id}/answers", 
        answer: @answer,
        rating: @answer.rating,
        attachments: @answer.attachments.as_json(methods: :with_meta),
        method: 'publish')
  end

  def destroy_answer
    ActionCable.server.broadcast("/questions/#{@answer.question_id}/answers",
      answer_id: @answer.id,
      method: 'delete')
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
