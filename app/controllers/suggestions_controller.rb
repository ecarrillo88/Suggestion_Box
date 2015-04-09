require 'image_manager.rb'

class SuggestionsController < ApplicationController
  before_action :set_suggestion, only: [:show, :edit, :update, :destroy]
  before_action :new_imageManager_filter, only: [:show, :edit]

  def index
    @suggestions = Suggestion.where(visible: true).paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
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
    @suggestion = suggestion_builder.create(suggestion_params, params[:image1_id], params[:image2_id])
    
    render :new and return if @suggestion.errors.any?
    
    flash[:info] = I18n.t('suggestions.create.flash_create_ok') if @suggestion.visible
    flash[:info] = I18n.t('suggestions.create.flash_email_info') if !@suggestion.visible
    redirect_to @suggestion
  end

  def update
      if @suggestion.update(suggestion_params)
        flash[:info] = t('.flash_update_ok')
        redirect_to @suggestion
      else
        render :edit
      end
  end

  def destroy
    @suggestion.destroy
    flash[:info] = t('.flash_destroy_ok')
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
