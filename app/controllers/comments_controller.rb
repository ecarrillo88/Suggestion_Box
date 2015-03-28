class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
  end

  def edit
  end

  def create
    comment_attr = comment_params
    @suggestion = Suggestion.find(params[:suggestion_id])
    unless params[:comment_and_support].nil?
      if email_has_supported?
        flash[:danger] = t('.flash_support_error')
        redirect_to suggestion_path(@suggestion) and return
      end
      comment_attr.merge!({support: true})
    end
    @comment = @suggestion.comments.create(comment_attr)
    if @comment.save
      if WhiteListEmail.find_by(email: comment_attr[:email]).nil?
        CommentMailer.comment_validation_email(@comment).deliver_later
        flash[:info] = t('.flash_email_info')
      else
        SupporterMailer.info_for_supporters(@comment).deliver_later if @comment.support
        send_info_email_to_supporters(@suggestion)
        @comment.update(visible: true)
        flash[:info] = t('.flash_create_ok')
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
    flash[:info] = t('.flash_destroy_ok')
    redirect_to @comment.suggestion
  end
  
  def validation
    email = Base64.decode64(params[:email])
    @comment = Comment.find_by(email: email)
    unless @comment.nil?
      SupporterMailer.info_for_supporters(@comment).deliver_later if @comment.support
      send_info_email_to_supporters(@comment.suggestion)
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
    def email_has_supported?
      @suggestion.comments.where(email: comment_params[:email], support: true).count > 0
    end
    
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
