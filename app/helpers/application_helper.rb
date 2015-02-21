module ApplicationHelper
  def presenter(model, presenter_class = nil)
    klass = presenter_class || "#{model.class}Presenter".constantize
    presenter = klass.new(model, self)
    yield presenter if block_given?
    presenter
  end
end
