class Comment < ActiveRecord::Base
  belongs_to :suggestion

  validates :author, presence: true,
                     length: { maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-_.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX }
  validates :text, presence: :true
  validates :vote, presence: true

  IN_FAVOUR = 1
  ABSTENTION = 2
  AGAINST = 3

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
    self.vote == Comment::IN_FAVOUR
  end

  def vote_against?
    self.vote == Comment::AGAINST
  end

  def supported?
    self.support
  end
end
