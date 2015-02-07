class Suggestion < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  
  validates :title, presence: :true
  validates :email, presence: :true
  validates :comment, presence: :true
end
