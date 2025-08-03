class PriceSnapshot < ApplicationRecord
  # Associations
  belongs_to :currency
  
  # Validations
  validates :last, presence: true, numericality: { greater_than: 0 }
  validates :bid, presence: true, numericality: { greater_than: 0 }
  validates :ask, presence: true, numericality: { greater_than: 0 }
  validates :captured_at, presence: true
  
  # Scopes
  scope :recent, -> { order(captured_at: :desc) }
  scope :for_currency, ->(currency) { where(currency: currency) }
  scope :within_hours, ->(hours) { where('captured_at >= ?', hours.hours.ago) }
  
  # Callbacks
  before_validation :set_captured_at, on: :create
  
  # Instance methods
  def spread
    ask - bid
  end
  
  def spread_percentage
    return 0 if bid.zero?
    (spread / bid * 100).round(2)
  end
  
  def formatted_captured_at
    captured_at.strftime('%Y-%m-%d %H:%M:%S')
  end
  
  private
  
  def set_captured_at
    self.captured_at ||= Time.current
  end
end
