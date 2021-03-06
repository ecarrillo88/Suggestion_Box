class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :report]

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
    rescue NeighbourComment::OnlyOneSupportPerPersonIsAllowed
      flash[:danger] = t('.flash_support_error')
    rescue CityCouncilComment::CityCouncilCannotSupport
      flash[:danger] = t('.flash_city_council_staff_support_error')
    rescue NeighbourComment::SuggestionClosed
      flash[:danger] = t('.flash_suggestion_closed')
    rescue CommentBuilder::ErrorSavingComment => error
      @comment = error.comment
      @image_manager = ImageManager.new
      render 'suggestions/show' and return
    else
      flash[:info] = t('.flash_email_info') if comment.is_a_city_council_staff_comment? || !comment.visible?
      flash[:info] = t('.flash_create_ok')  if comment.visible?
    end
    redirect_to @suggestion
  end

  def update
  end

  def destroy
    if !Comment.exists?(params[:id])
      flash[:danger] = t('.flash_destroy_error')
      redirect_to suggestion_path(params[:suggestion_id])
      return
    end

    set_comment
    if params[:token].nil?
      @comment.update(token_validation: ApplicationController.token_generator(10))
      CommentMailer.delete_comment_email_validation(@comment).deliver_later
      flash[:info] = t('.flash_email_info')
    else
      if params[:token] == @comment.token_validation
        @comment.destroy
        flash[:info] = t('.flash_destroy_ok')
      else
        flash[:danger] = t('.flash_destroy_token_error')
      end
    end
    redirect_to @comment.suggestion
  end

  def report
    CityCouncilResponsiblePerson.all.each do |responsible_person|
      CommentMailer.report_comment(@comment, responsible_person).deliver_later
    end
    flash[:info] = t('.flash_report_ok')
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
