class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
  end

  def edit
  end

  def create
    @suggestion = Suggestion.find(params[:suggestion_id])
    @comment = @suggestion.comments.create(comment_params)
    if @comment.save
      if WhiteListEmail.find_by(email: comment_params[:email]).nil?
        CommentMailer.comment_validation_email(@comment).deliver_later
        flash[:info] = 'In a few moments you will receive an email to confirm your comment.'
      else
        @comment.update(visible: true)
        flash[:info] = 'Comment was successfully published.'
      end
      redirect_to suggestion_path(@suggestion)
    else
      @comments = Suggestion.find(params[:suggestion_id]).comments
      render 'suggestions/show'
    end
  end

  def update
  end

  def destroy
    @comment.destroy
    flash[:info] = 'Comment was successfully destroyed.'
    redirect_to @comment.suggestion
  end
  
  def validation
    email = Base64.decode64(params[:email])
    @comment = Comment.find_by(email: email)
    unless @comment.nil?
      @comment.update(visible: true)
      # Add email to white list
      if WhiteListEmail.find_by(email: email).nil?
        WhiteListEmail.new(email: email).save
      end
      render 'comments/validation_success'
    else
      render 'comments/validation_failed'
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:author, :text, :email)
    end
end
