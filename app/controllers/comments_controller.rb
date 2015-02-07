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
      flash[:success] = 'Comment was successfully created.'
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

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:author, :text)
    end
end
