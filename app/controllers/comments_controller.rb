class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:create]
  
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

  def set_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return @commentable = $1.classify.constantize.find(value)
      end
    end
  end
end