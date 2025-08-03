class Currency < ApplicationRecord
  # Associations
  has_many :price_snapshots, dependent: :destroy
  
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :symbol, presence: true, uniqueness: true, format: { with: /\A[A-Z]{3,10}\z/ }
  
  # Scopes
  scope :ordered, -> { order(:name) }
  
  # Instance methods
  def latest_price
    price_snapshots.order(captured_at: :desc).first
  end
  
  def latest_price_value
    latest_price&.last
  end
  
  # Class methods
  def self.btc
    find_by(symbol: 'BTCAUD')
  end
  
  def self.eth
    find_by(symbol: 'ETHAUD')
  end
end
