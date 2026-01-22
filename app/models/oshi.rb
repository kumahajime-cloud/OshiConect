class Oshi < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :name, presence: true, length: { minimum: 1, maximum: 50 }
  validates :name, uniqueness: { scope: :user_id, message: "は既に登録されています" }
end
