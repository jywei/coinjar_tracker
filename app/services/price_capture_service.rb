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
    rescue StandardError => e
      results[:errors] << { symbol: currency.symbol, error: e.message }

      Rails.logger.error("Failed to capture price for #{currency.symbol}: #{e.message}")
    end

    results
  end

  def capture_for_currency(currency)
    # Can potentially use ports and adapters pattern to reduce coupling
    ticker_data = CoinjarApiClient.fetch_ticker(currency.symbol)

    create_price_snapshot(currency, ticker_data)

    Rails.logger.info("Successfully captured price for #{currency.symbol}: #{ticker_data['last']}")
  rescue ActiveRecord::RecordInvalid => e
    raise CoinjarApiClient::InvalidResponseError, "Invalid data for #{currency.symbol}: #{e.message}"
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
