class SuggestionsController < ApplicationController
  protect_from_forgery except: :index

  before_action :set_suggestion, only: [:show, :edit, :edit_request, :update, :report]
  before_action :new_image_manager_filter, only: [:show, :edit, :update, :new]

  def index
    @suggestions = Suggestion.all
      .order(created_at: :desc)
      .paginate(:page => params[:page], :per_page => 10)
  end

  def show
  end

  def new
    @suggestion = Suggestion.new
  end

  def create
    suggestion_builder = SuggestionBuilder.new
    @suggestion = suggestion_builder.create(suggestion_params, params[:image1_id], params[:image2_id])

    render :new and return if @suggestion.has_errors?

    flash[:info] = I18n.t('suggestions.create.flash_create_ok') if @suggestion.visible?
    flash[:info] = I18n.t('suggestions.create.flash_email_info') if !@suggestion.visible?
    redirect_to @suggestion
  end

  def advanced_search
    @title = params[:title]
    @category = params[:category]
    @status = params[:status]
    @address = params[:address]
    @distance = params[:distance]
    @suggestions = Suggestion.search_filter(@title, @category, @status, @address, @distance)
      .paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def report
    CityCouncilResponsiblePerson.all.each do |responsible_person|
      SuggestionMailer.report_suggestion(@suggestion, responsible_person).deliver_later
    end
    flash[:info] = t('.flash_report_ok')
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
    @image_manager = ImageManagerFactory.create.new
  end

  def suggestion_params
    params.require(:suggestion).permit(:title, :category, :author, :email, :comment, :latitude, :longitude)
  end
end
