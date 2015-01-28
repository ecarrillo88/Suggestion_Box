class SuggestionBoxController < ApplicationController
  def index
    @suggestions = Suggestion.all.order(created_at: :desc)
  end
end
