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
    comment_builder = CommentBuilder.new
    flash_type, flash_msg, action = comment_builder.create(comment_params, @suggestion, params[:comment_and_support])
    flash.now[flash_type] = t(flash_msg) unless flash_type.nil? || flash_msg.nil?
    if action == 'redirect'
      redirect_to @suggestion
    else
      @comment = @suggestion.comments.last
      @comments = Suggestion.find(@suggestion.id).comments
      render 'suggestions/show'
    end
  end

  def update
  end

  def destroy
    @comment.destroy
    flash[:info] = t('.flash_destroy_ok')
    redirect_to @comment.suggestion
  end
  
  def validation
    email = Base64.decode64(params[:email])
    @comment = Comment.where(email: email).order("id DESC").first
    unless @comment.nil?
      SupporterMailer.info_for_supporters(@comment).deliver_later if @comment.support
      send_info_email_to_supporters(@comment.suggestion)
      @comment.update(visible: true)
      # Add email to white list
      if WhiteListEmail.find_by(email: email).nil? && @comment.city_council_staff == false
        WhiteListEmail.new(email: email).save
      end
      render 'comments/validation_success'
    else
      render 'comments/validation_failed'
    end
  end

  private
    def send_info_email_to_supporters(suggestion)
      email_set = Set.new
      suggestion.comments.each do |comment|
        email_set.add(comment.email) if comment.support
      end
      email_set.delete(@comment.email)
      email_set.each do |email|
        SupporterMailer.info_new_comment(suggestion, @comment, email).deliver_later
      end
    end
    
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:author, :text, :email)
    end
end
