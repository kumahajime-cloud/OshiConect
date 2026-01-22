class Post < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :post_hashtags, dependent: :destroy
  has_many :hashtags, through: :post_hashtags
  has_many :likes, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user

  # Active Storage for image attachment
  has_one_attached :image

  # Validations
  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }

  # Callbacks
  after_create :extract_hashtags

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :with_hashtag, ->(hashtag_name) { joins(:hashtags).where(hashtags: { name: hashtag_name }) }

  # Methods
  def likes_count
    likes.count
  end

  private

  def extract_hashtags
    # Extract hashtags from content (e.g., #推しの名前)
    hashtag_names = content.scan(/#[一-龠ぁ-んァ-ヶーa-zA-Z0-9]+/).map { |tag| tag[1..-1] }

    hashtag_names.uniq.each do |name|
      hashtag = Hashtag.find_or_create_by(name: name)
      post_hashtags.create(hashtag: hashtag) unless hashtags.include?(hashtag)
    end
  end
end
