require 'net/http'
require 'json'

class PriceCaptureService
  # API configuration
  API_BASE_URL = 'https://data.exchange.coinjar.com/products'.freeze
  REQUEST_TIMEOUT = 10 # seconds
  
  # Error classes for better error handling
  class ApiError < StandardError; end
  class InvalidResponseError < StandardError; end
  
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
    # Fetch latest price data from API
    ticker_data = fetch_ticker_data(currency.symbol)
    
    # Create price snapshot
    PriceSnapshot.create!(
      currency: currency,
      last: ticker_data['last'],
      bid: ticker_data['bid'],
      ask: ticker_data['ask'],
      captured_at: Time.current
    )
    
    Rails.logger.info("Successfully captured price for #{currency.symbol}: #{ticker_data['last']}")
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidResponseError, "Invalid data for #{currency.symbol}: #{e.message}"
  end
  
  private
  
  def fetch_ticker_data(symbol)
    uri = URI("#{API_BASE_URL}/#{symbol}/ticker")
    
    # Configure HTTP request
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = REQUEST_TIMEOUT
    http.read_timeout = REQUEST_TIMEOUT
    
    # Make request
    response = http.get(uri.request_uri)
    
    # Handle response
    case response
    when Net::HTTPSuccess
      parse_response(response.body)
    when Net::HTTPNotFound
      raise ApiError, "Symbol #{symbol} not found"
    when Net::HTTPTooManyRequests
      raise ApiError, "Rate limit exceeded for #{symbol}"
    else
      raise ApiError, "HTTP #{response.code}: #{response.message}"
    end
  rescue Timeout::Error
    raise ApiError, "Request timeout for #{symbol}"
  rescue JSON::ParserError => e
    raise InvalidResponseError, "Invalid JSON response for #{symbol}: #{e.message}"
  rescue SocketError => e
    raise ApiError, "Network error for #{symbol}: #{e.message}"
  end
  
  def parse_response(body)
    data = JSON.parse(body)
    
    # Validate required fields
    required_fields = %w[last bid ask]
    missing_fields = required_fields - data.keys
    
    if missing_fields.any?
      raise InvalidResponseError, "Missing required fields: #{missing_fields.join(', ')}"
    end
    
    # Validate numeric values
    required_fields.each do |field|
      value = data[field]
      unless value.is_a?(Numeric) || (value.is_a?(String) && value.match?(/\A\d+(\.\d+)?\z/))
        raise InvalidResponseError, "Invalid #{field} value: #{value}"
      end
    end
    
    data
  end
end 