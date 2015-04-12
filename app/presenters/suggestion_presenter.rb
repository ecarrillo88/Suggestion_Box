class SuggestionPresenter < BasePresenter
  presents :suggestion
  
  def comments
    suggestion.comments.where(visible: true).size
  end
  
  def supporters
    suggestion.comments.where(visible: true, support: true).size
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
  
  def activated?
    suggestion.visible?
  end
  
  def progress_in_favour
    total = suggestion.comments.where("vote = 1 OR vote = 3").size
    in_favour = suggestion.comments.where(vote: 1).size
    if total != 0
      return ((in_favour.to_f / total) * 100).to_i 
    else
      return 0
    end
  end
  
  def progress_against
    against = suggestion.comments.where(vote: 3).size
    if against != 0
      return 100 - progress_in_favour
    else
      return 0
    end
  end
end