require 'net/http'
require 'json'

class CoinjarApiClient
  API_BASE_URL = 'https://data.exchange.coinjar.com/products'.freeze
  REQUEST_TIMEOUT = 10 # seconds
  
  # Error classes for better error handling
  class ApiError < StandardError; end
  class InvalidResponseError < StandardError; end
  
  # Fetch ticker data for a specific symbol
  def self.fetch_ticker(symbol)
    new.fetch_ticker(symbol)
  end
  
  # Instance method for fetching ticker data
  def fetch_ticker(symbol)
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
  
  private
  
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