class Suggestion < ActiveRecord::Base
  validates :title, presence: :true
  validates :email, presence: :true
  validates :comment, presence: :true
end
