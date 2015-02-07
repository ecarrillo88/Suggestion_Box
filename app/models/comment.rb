class Comment < ActiveRecord::Base
  belongs_to :suggestion

  validates :author, presence: true,
                     length: { maximum: 25 }
  validates :text, presence: :true
end
