class PostHashtag < ApplicationRecord
  # Associations
  belongs_to :post
  belongs_to :hashtag

  # Validations
  validates :post_id, uniqueness: { scope: :hashtag_id }
end
