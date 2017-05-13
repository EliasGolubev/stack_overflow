class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:new, :create, :update, :destroy]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :build_answer, only: [:show]
  before_action :destroy_question, only: [:destroy]

  after_action :publish_question, only: [:create]

  respond_to :js

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with @question = current_user.questions.create(question_params)
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions',
      render: ApplicationController.render(partial:'questions/question', locals: { question: @question }),
      method: 'publish'
  end

  def destroy_question
    ActionCable.server.broadcast 'questions',
    question_id: @question.id,
    method: 'destroy' if current_user.author?(@question)
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
