require 'net/http'
require 'json'

class PriceCaptureService
  # Capture prices for all currencies
  def self.capture_all
    new.capture_all
  end
  
  # Capture price for a specific currency
  def self.capture_for_currency(currency)
    new.capture_for_currency(currency)
  end
  
  # Instance methods
  def capture_all
    results = { success: [], errors: [] }
    
    Currency.find_each do |currency|
      begin
        capture_for_currency(currency)
        results[:success] << currency.symbol
      rescue StandardError => e
        results[:errors] << { symbol: currency.symbol, error: e.message }
        Rails.logger.error("Failed to capture price for #{currency.symbol}: #{e.message}")
      end
    end
    
    results
  end
  
  def capture_for_currency(currency)
    # Fetch latest price data from API using the dedicated client
    ticker_data = CoinjarApiClient.fetch_ticker(currency.symbol)
    
    # Create price snapshot with business logic
    create_price_snapshot(currency, ticker_data)
    
    Rails.logger.info("Successfully captured price for #{currency.symbol}: #{ticker_data['last']}")
  rescue ActiveRecord::RecordInvalid => e
    raise CoinjarApiClient::InvalidResponseError, "Invalid data for #{currency.symbol}: #{e.message}"
  end
  
  private
  
  def create_price_snapshot(currency, ticker_data)
    PriceSnapshot.create!(
      currency: currency,
      last: ticker_data['last'],
      bid: ticker_data['bid'],
      ask: ticker_data['ask'],
      captured_at: Time.current
    )
  end
end 