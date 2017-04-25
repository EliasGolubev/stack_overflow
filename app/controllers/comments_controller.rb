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

  def publish_comments
    return if @comment.errors.any?

    ActionCable.server.broadcast("/questions/#{@question_id}/comments",
      comentable_id: @comment.commentable_id,
      comment: @comment)
  end

  def get_question_id
    if @commentable.class.name == "Question"
      @question_id = @commentable.id
    else
      @question_id = @commentable.question_id
    end
  end

  def set_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return @commentable = $1.classify.constantize.find(value)
      end
    end
  end
end