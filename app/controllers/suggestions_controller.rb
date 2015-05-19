require 'image_manager.rb'

class SuggestionsController < ApplicationController
  before_action :set_suggestion, only: [:show, :edit, :edit_request, :update]
  before_action :new_image_manager_filter, only: [:show, :edit, :update]

  def index
    @suggestions = Suggestion.search_filter(params[:category], params[:title], params[:address], params[:distance])
                             .paginate(:page => params[:page], :per_page => 10)
  end

  def show
  end

  def new
    @suggestion = Suggestion.new
  end

  def edit
    if params[:token].nil?
      @suggestion.update(token_validation: ApplicationController.token_generator(10))
      SuggestionMailer.edit_suggestion_email_validation(@suggestion).deliver_later
      flash[:info] = t('.flash_email_info')
      redirect_to @suggestion
    else
      if params[:token] == @suggestion.token_validation
        @suggestion.update(token_validation: nil)
        render 'edit'
      else
        flash[:danger] = t('.flash_edit_token_error')
        redirect_to @suggestion
      end
    end
  end

  def create
    suggestion_builder = SuggestionBuilder.new
    @suggestion = suggestion_builder.create(suggestion_params, params[:image1_id], params[:image2_id])

    render :new and return if @suggestion.has_errors?

    flash[:info] = I18n.t('suggestions.create.flash_create_ok') if @suggestion.visible?
    flash[:info] = I18n.t('suggestions.create.flash_email_info') if !@suggestion.visible?
    redirect_to @suggestion
  end

  def update
    images = {}
    images[:image1_id] = update_image(params[:image1_id], @suggestion.image1_id)
    images[:image2_id] = update_image(params[:image2_id], @suggestion.image2_id)

    if @suggestion.update(suggestion_params.merge(images))
      flash[:info] = t('.flash_update_ok')
      redirect_to @suggestion
    else
      render :edit
    end
  end

  def destroy
    if !Suggestion.exists?(params[:id])
      flash[:danger] = t('.flash_destroy_error')
      redirect_to suggestions_url
      return
    end

    set_suggestion
    if params[:token].nil?
      @suggestion.update(token_validation: ApplicationController.token_generator(10))
      SuggestionMailer.delete_suggestion_email_validation(@suggestion).deliver_later
      flash[:info] = t('.flash_email_info')
    else
      if params[:token] == @suggestion.token_validation
        @suggestion.comments_email_list.each { |email| SuggestionMailer.info_suggestion_has_been_deleted(@suggestion, email).deliver_later }
        @suggestion.destroy
        flash[:info] = t('.flash_destroy_ok')
      else
        flash[:danger] = t('.flash_destroy_token_error')
      end
    end
    redirect_to @suggestion
  end

  private
    def update_image(image_param, image_id)
      return image_id if image_param.nil?

      if image_param.blank?
        @image_manager.delete_image(image_id) if !image_id.nil?
        return nil
      end

      @image_manager.delete_image(image_id) if !image_id.nil?
      hash = @image_manager.upload_image(image_param)
      return hash['public_id']
    end

    def set_suggestion
      @suggestion = Suggestion.friendly.find(params[:id])
    end

    def new_image_manager_filter
      @image_manager = ImageManager.new
    end

    def suggestion_params
      params.require(:suggestion).permit(:title, :category, :author, :email, :comment, :latitude, :longitude)
    end
end
