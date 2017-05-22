class Api::V1::AnswersController < Api::V1::BaseController
  
  before_action :load_question, only: [:index, :create]

  authorize_resource class: Answer

  def index
    respond_with @answers = @question.answers
  end

  def show
    respond_with @answer = Answer.find(params[:id])
  end

  def create
    respond_with @answer = @question.answers.create(answer_params.merge(user_id: current_resource_owner.id))
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
