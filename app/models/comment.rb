class Comment < ActiveRecord::Base
  belongs_to :suggestion

  validates :author, presence: true,
                     length: { maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX }
  validates :text, presence: :true
end
