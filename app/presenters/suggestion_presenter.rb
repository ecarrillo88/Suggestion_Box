class SuggestionPresenter < BasePresenter
  presents :suggestion
  
  def comments
    suggestion.comments.where(visible: true).size
  end
  
  def created_at
    suggestion.created_at.to_formatted_s(:long)
  end
  
  def has_map?
    !suggestion.latitude.nil? && !suggestion.longitude.nil?
  end
  
  def has_comments?
    comments > 0
  end
  
  def has_image1?
    !suggestion.image1_id.nil?
  end
  
  def has_image2?
    !suggestion.image2_id.nil?
  end
  
  def has_images?
    has_image1? || has_image2?
  end
end