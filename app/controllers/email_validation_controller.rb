class EmailValidationController < ApplicationController

  def comment_validation
    email = Base64.decode64(params[:email])
    @comment = Comment.where(email: email).order("id DESC").first
    unless @comment.nil?
      SupporterMailer.info_for_supporters(@comment).deliver_later if @comment.supported?
      send_info_email_to_supporters(@comment.suggestion)
      @comment.update(visible: true)
      # Add email to white list
      if WhiteListEmail.not_in_whitelist?(email) && !@comment.is_a_city_council_staff_comment?
        WhiteListEmail.new(email: email).save
      end
      render 'comment_validation_success'
    else
      render 'comment_validation_failed'
    end
  end

  def suggestion_validation
    @suggestion = Suggestion.find_by(token_validation: params[:token])
    unless @suggestion.nil?
      @suggestion.update(visible: true)
      # Add email to white list
      if WhiteListEmail.not_in_whitelist?(@suggestion.email)
        WhiteListEmail.new(email: @suggestion.email).save
      end
      render 'suggestion_validation_success'
    else
      render 'suggestion_validation_failed'
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
