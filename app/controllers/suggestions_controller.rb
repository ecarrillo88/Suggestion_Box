require 'image_manager.rb'

class SuggestionsController < ApplicationController
  before_action :set_suggestion, only: [:show, :edit, :update, :destroy]
  before_action :new_imageManager_filter, only: [:show, :edit, :create]

  def index
    @suggestions = Suggestion.where(visible: true).order(created_at: :desc)
  end

  def show
    @comments = Suggestion.find(params[:id]).comments.where(visible: true)
  end

  def new
    @suggestion = Suggestion.new
  end

  def edit
  end

  def create
    sp = suggestion_params
    unless params[:image1_id].nil?
      sp[:image1_id] = uploadImageToCloudinary(params[:image1_id])
    end
    unless params[:image2_id].nil?
      sp[:image2_id] = uploadImageToCloudinary(params[:image2_id])
    end
    
    @suggestion = Suggestion.new(sp)
    if @suggestion.save
      token_MD5 = Digest::MD5.hexdigest(@suggestion.id.to_s + @suggestion.email)
      @suggestion.update(token_validation: token_MD5)
      SuggestionMailer.suggestion_validation_email(@suggestion).deliver_later
      flash[:info] = 'In a few moments you will receive an email to confirm the suggestion.'
      redirect_to @suggestion
    else
      render :new
    end
  end

  def update
      if @suggestion.update(suggestion_params)
        flash[:info] = 'Suggestion was successfully updated'
        redirect_to @suggestion
      else
        render :edit
      end
  end

  def destroy
    @suggestion.destroy
    flash[:info] = 'Suggestion was successfully destroyed'
    redirect_to suggestions_url
  end
  
  def validation
    @suggestion = Suggestion.find_by(token_validation: params[:token])
    unless @suggestion.nil?
      @suggestion.update(visible: true)
      render 'suggestions/validation'
    else
      render 'suggestions/fail'
    end
  end

  private
    def set_suggestion
      @suggestion = Suggestion.find(params[:id])
    end
    
    def new_imageManager_filter
      @imageManager = ImageManager.new
    end
    
    def uploadImageToCloudinary(image_param)
      image_hash = @imageManager.upload_image(image_param)
      return image_hash['public_id']
    end

    def suggestion_params
      params.require(:suggestion).permit(:title, :author, :email, :comment, :latitude, :longitude)
    end
end
