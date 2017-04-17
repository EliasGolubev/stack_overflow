class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:new, :create, :update, :destroy]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :destroy_question, only: [:destroy]

  after_action :publish_question, only: [:create]


  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = current_user.questions.create(question_params)
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
    render :update
  end

  def destroy
    @question.destroy if current_user.author?(@question)

    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
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
    method: 'destroy'
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
