class SuggestionsController < ApplicationController
  before_action :set_suggestion, only: [:show, :edit, :update, :destroy]

  def index
    @suggestions = Suggestion.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @suggestion = Suggestion.new
  end

  def edit
  end

  def create
    @suggestion = Suggestion.new(suggestion_params)
    if @suggestion.save
      flash[:success] = 'Suggestion was successfully created'
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

  private
    def set_suggestion
      @suggestion = Suggestion.find(params[:id])
    end

    def suggestion_params
      params.require(:suggestion).permit(:title, :author, :email, :comment)
    end
end
