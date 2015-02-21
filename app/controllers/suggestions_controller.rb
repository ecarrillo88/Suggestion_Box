require 'image_manager.rb'

class SuggestionsController < ApplicationController
  before_action :set_suggestion, only: [:show, :edit, :update, :destroy]
  before_action :new_imageManager_filter, only: [:show, :edit]

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
    suggestion_builder = SuggestionBuilder.new
    suggestion_hash = suggestion_builder.create(suggestion_params, params[:image1_id], params[:image2_id])
    @suggestion = suggestion_hash[:suggestion]
    if suggestion_hash[:save]
      flash[:info] = suggestion_hash[:msg]
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
      # Add email to white list
      if WhiteListEmail.find_by(email: @suggestion.email).nil?
        WhiteListEmail.new(email: @suggestion.email).save
      end
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

    def suggestion_params
      params.require(:suggestion).permit(:title, :author, :email, :comment, :latitude, :longitude)
    end
end
