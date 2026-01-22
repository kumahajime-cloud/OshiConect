class Hashtag < ApplicationRecord
  # Associations
  has_many :post_hashtags, dependent: :destroy
  has_many :posts, through: :post_hashtags

  # Validations
  validates :name, presence: true, uniqueness: true

  # Methods
  def posts_count
    posts.count
  end
end
