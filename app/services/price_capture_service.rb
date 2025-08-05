require "net/http"
require "json"

class PriceCaptureService
  def self.capture_all
    new.capture_all
  end

  def self.capture_for_currency(currency)
    new.capture_for_currency(currency)
  end

  def capture_all
    results = { success: [], errors: [] }

    Currency.find_each do |currency|
      capture_for_currency(currency)
      results[:success] << currency.symbol
    rescue CoinjarApiClient::ApiError => e
      results[:errors] << { symbol: currency.symbol, error: e.message }
      Rails.logger.warn("API error for #{currency.symbol}: #{e.message}")
    rescue CoinjarApiClient::InvalidResponseError => e
      results[:errors] << { symbol: currency.symbol, error: e.message }
      Rails.logger.error("Invalid response for #{currency.symbol}: #{e.message}")
    rescue ActiveRecord::RecordInvalid => e
      results[:errors] << { symbol: currency.symbol, error: "Validation failed: #{e.message}" }
      Rails.logger.error("Validation failed for #{currency.symbol}: #{e.message}")
    end

    results
  end

  def capture_for_currency(currency)
    # Can potentially use ports and adapters pattern to reduce coupling
    ticker_data = CoinjarApiClient.fetch_ticker(currency.symbol)
    create_price_snapshot(currency, ticker_data)
    
    Rails.logger.info("Successfully captured price for #{currency.symbol}: #{ticker_data['last']}")
  end

  private

  def create_price_snapshot(currency, ticker_data)
    PriceSnapshot.create!(
      currency: currency,
      last: ticker_data["last"],
      bid: ticker_data["bid"],
      ask: ticker_data["ask"],
      captured_at: Time.current
    )
  end
end
