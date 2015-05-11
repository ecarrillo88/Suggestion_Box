class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
  end

  def edit
  end

  def create
    @suggestion = Suggestion.friendly.find(params[:suggestion_id])
    comment_builder = CommentBuilder.new
    begin
      comment = comment_builder.create(comment_params, @suggestion, !params[:comment_and_support].nil?)
    rescue CommentBuilder::OnlyOneSupportPerPersonIsAllowed
      flash[:danger] = t('.flash_support_error')
      redirect_to @suggestion
    rescue CommentBuilder::CityCouncilCannotSupport
      flash[:danger] = t('.flash_city_council_staff_support_error')
      redirect_to @suggestion
    rescue CommentBuilder::ErrorSavingComment => error
      @comment = error.comment
      @image_manager = ImageManager.new
      render 'suggestions/show'
    else
      flash[:info] = t('.flash_email_info') if comment.is_a_city_council_staff_comment? || !comment.visible?
      flash[:info] = t('.flash_create_ok')  if comment.visible?
      redirect_to @suggestion
    end
  end

  def update
  end

  def destroy
    @comment.destroy
    flash[:info] = t('.flash_destroy_ok')
    redirect_to @comment.suggestion
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:author, :text, :email, :vote)
    end
end
