class Comment < ActiveRecord::Base
  belongs_to :suggestion

  validates :author, presence: true,
                     length: { maximum: 25 }
  validates :email, presence: :true
  validates :text, presence: :true
end
