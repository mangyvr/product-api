class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true

  scope :not_deleted, -> { where(deleted_at: nil) }
  scope :with_views, -> { where('view_count >= 1') }
end
