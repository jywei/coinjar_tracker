class Currency < ApplicationRecord
  has_many :price_snapshots, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  # Validate symbol is 3-10 uppercase letters
  validates :symbol, presence: true, uniqueness: true, format: { with: /\A[A-Z]{3,10}\z/ }
  
  scope :ordered, -> { order(:name) }
  
  def latest_price
    price_snapshots.order(captured_at: :desc).first
  end
  
  def latest_price_value
    latest_price&.last
  end
end
