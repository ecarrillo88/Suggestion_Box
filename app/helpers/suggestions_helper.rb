module SuggestionsHelper
  def form_url(current_url)
    action = current_url.split('/')
    return create_suggestion_path if action.last == 'new'
    return update_suggestion_path if action.last == 'edit'
  end
end
