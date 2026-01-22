class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :oshis, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  # Active Storage for profile image
  has_one_attached :profile_image

  # Validations
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }
  validates :bio, length: { maximum: 500 }

  # Methods
  def liked?(post)
    liked_posts.include?(post)
  end
end
