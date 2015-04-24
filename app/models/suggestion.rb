class Suggestion < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  def should_generate_new_friendly_id?
    title_changed?
  end

  has_many :comments, dependent: :destroy

  validates :title, presence: :true,
                    length: { maximum: 150 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX }
  validates :comment, presence: :true
end
