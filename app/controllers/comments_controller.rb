class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:create]
  before_action :get_question_id, only: [:create]
  before_action :load_comment, only: [:destroy]

  after_action :publish_comments, only: [:create]
  
  respond_to :js

  authorize_resource

  def create
    respond_with @comment = @commentable.comments.create(comments_params.merge(user_id: current_user.id))
  end

  def destroy
    respond_with @comment.destroy if current_user.author?(@comment)
  end

  private

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def comments_params
    params.require(:comment).permit(:body)
  end

  def commentable_name
    params[:commentable]
  end

  def commentable_klass
    commentable_name.classify.constantize
  end

  def set_commentable
    @commentable = commentable_klass.find(params["#{commentable_name}_id"])
  end

  def get_question_id   
    if @commentable.class.name == "Question"
      @question_id = @commentable.id
    else
      @question_id = @commentable.question_id
    end
  end

  def publish_comments
    return if @comment.errors.any?

    ActionCable.server.broadcast("/questions/#{@question_id}/comments",
      comentable_id: @comment.commentable_id,
      comment: @comment,
      commentable_klass: @commentable.class.name)
  end
end