class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    { locale: I18n.locale }
  end

  def self.token_generator(length)
    lowercase = ("a".."z")
    uppercase = ("A".."Z")
    numbers = (0..9)
    array = lowercase.to_a + uppercase.to_a + numbers.to_a
    token = array.shuffle[0,length].join
  end
end
