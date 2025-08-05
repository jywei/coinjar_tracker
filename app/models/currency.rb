class Currency < ApplicationRecord
  has_many :price_snapshots, dependent: :destroy

  validates :name, presence: true
  # Validate symbol is 3-10 uppercase letters
  validates :symbol, presence: true, format: { with: /\A[A-Z]{3,10}\z/ }

  scope :ordered, -> { order(:name) }
  scope :with_latest_price, -> {
    joins("LEFT JOIN price_snapshots latest ON latest.currency_id = currencies.id AND latest.captured_at = (
      SELECT MAX(captured_at) FROM price_snapshots WHERE currency_id = currencies.id
    )")
  }

  def latest_price
    price_snapshots.order(captured_at: :desc).limit(1).first
  end

  def latest_price_value
    latest_price&.last
  end
end
