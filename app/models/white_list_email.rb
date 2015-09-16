class WhiteListEmail < ActiveRecord::Base
  def self.in_whiteList?(email)
    return true if Rails.env != 'production'

    !find_by(email: email).nil?
  end

  def self.not_in_whitelist?(email)
    find_by(email: email).nil?
  end
end
