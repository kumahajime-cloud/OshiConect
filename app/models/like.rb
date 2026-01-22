class Like < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :post, counter_cache: true

  # Validations
  validates :user_id, uniqueness: { scope: :post_id, message: "は既にいいねしています" }
end
