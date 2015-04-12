module ApplicationHelper
  def presenter(model, presenter_class = nil)
    klass = presenter_class || "#{model.class}Presenter".constantize
    presenter = klass.new(model, self)
    yield presenter if block_given?
    presenter
  end
  
  def set_header_title(header_title)
    return "<h1>#{I18n.t('header.title')}</h1>".html_safe if header_title.empty?
    return header_title
  end
  
  def set_header_description(header_description)
    return I18n.t('header.description') if header_description.empty?
    return header_description
  end
  
  def set_header_button(header_button)
    return link_to I18n.t('header.new_suggestion_button'), new_suggestion_path, class: 'btn btn-primary btn-lg' if header_button.empty?
    return "" if header_button == 'no'
    return header_button
  end
  
  def created_at(object)
    date = object.created_at
    if I18n.locale == :es
      months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Dicicembre"]
      return "#{date.day} de #{months[date.month-1]}, #{date.year}"
    else
      return "#{date.strftime("%B")} #{date.day}, #{date.year}"
    end
  end
end
