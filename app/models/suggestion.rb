class Suggestion < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  
  validates :title, presence: :true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX }
  validates :comment, presence: :true
end
