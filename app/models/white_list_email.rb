class WhiteListEmail < ActiveRecord::Base
  def self.in_whiteList?(email)
    return true if Rails.env == 'development'

    !find_by(email: email).nil?
  end

  def self.not_in_whitelist?(email)
    find_by(email: email).nil?
  end
end
