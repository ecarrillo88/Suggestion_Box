class Comment < ActiveRecord::Base
  belongs_to :suggestion

  validates :author, presence: true,
                     length: { maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-_.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX }
  validates :text, presence: :true
  validates :vote, presence: true

  def self.vote
    { in_favour: 1, abstention: 2, against: 3 }
  end

  def self.exists?(comment_id)
    where(id: comment_id).present?
  end

  def visible?
    self.visible
  end

  def is_a_city_council_staff_comment?
    self.city_council_staff
  end

  def vote_in_favour?
    self.vote == Comment.vote[:in_favour]
  end

  def vote_against?
    self.vote == Comment.vote[:against]
  end

  def supported?
    self.support
  end
end
