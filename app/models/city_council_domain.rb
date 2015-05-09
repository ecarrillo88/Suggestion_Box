class CityCouncilDomain < ActiveRecord::Base

  def self.is_city_council_staff?(email)
     where(domain: email.split('@').last).any?
  end
end
