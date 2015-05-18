class EmailValidationController < ApplicationController

  def comment_validation
    @comment = Comment.find_by(token_validation: params[:token])
    unless @comment.nil?
      SupporterMailer.info_for_supporters(@comment).deliver_later if @comment.supported?
      send_info_email_to_supporters(@comment.suggestion)
      @comment.update(visible: true, token_validation: nil)
      # Add email to white list
      if WhiteListEmail.not_in_whitelist?(@comment.email) && !@comment.is_a_city_council_staff_comment?
        WhiteListEmail.new(email: @comment.email).save
      end
      flash[:info] = t('.flash_comment_validation_success')
      redirect_to @comment.suggestion
    else
      render 'comment_validation_failed'
    end
  end

  def suggestion_validation
    @suggestion = Suggestion.find_by(token_validation: params[:token])
    unless @suggestion.nil?
      @suggestion.update(visible: true, token_validation: nil)
      # Add email to white list
      if WhiteListEmail.not_in_whitelist?(@suggestion.email)
        WhiteListEmail.new(email: @suggestion.email).save
      end
      flash[:info] = t('.flash_suggestion_validation_success')
      redirect_to @suggestion
    else
      render 'suggestion_validation_failed'
    end
  end

  def edit_suggestion_validation
    @suggestion = Suggestion.find_by(token_validation: params[:token])
    unless @suggestion.nil?
      @suggestion.update(token_validation: nil)
      redirect_to edit_suggestion_path(@suggestion)
    else
      render 'edit_suggestion_validation_failed'
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
end
