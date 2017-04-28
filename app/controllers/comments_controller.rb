class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:create]
  before_action :get_question_id, only: [:create]

  after_action :publish_comments, only: [:create]
  
  def create
    @comment = @commentable.comments.build(comments_params)
    @comment.user_id = current_user.id
    @comment.save 
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if current_user.author?(@comment)
  end

  private

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