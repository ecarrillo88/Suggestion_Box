module ApplicationHelper
  def presenter(model, presenter_class = nil)
    klass = presenter_class || "#{model.class}Presenter".constantize
    presenter = klass.new(model, self)
    yield presenter if block_given?
    presenter
  end
  
  def set_header_title(header_title)
    return '<h1>Suggestion Box</h1>'.html_safe if header_title.empty?
    return header_title
  end
  
  def set_header_description(header_description)
    return 'Drop your comments, questions, requests and complaints' if header_description.empty?
    return header_description
  end
  
  def set_header_button(header_button)
    return link_to 'Create a new Suggestion', new_suggestion_path, class: 'btn btn-primary btn-lg' if header_button.empty?
    return "" if header_button == 'no'
    return header_button
  end
end
