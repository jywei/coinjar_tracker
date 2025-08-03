require "test_helper"

class CoinjarApiClientTest < ActiveSupport::TestCase
  def setup
    @client = CoinjarApiClient.new
  end

  test "fetch_ticker should return valid ticker data" do
    mock_response = {
      "last" => "50000.00",
      "bid" => "49900.00",
      "ask" => "50100.00"
    }
    
    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: mock_response.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    result = @client.fetch_ticker("BTCAUD")
    
    assert_equal "50000.00", result["last"]
    assert_equal "49900.00", result["bid"]
    assert_equal "50100.00", result["ask"]
  end

  test "fetch_ticker should handle string numeric values" do
    mock_response = {
      "last" => "50000.50",
      "bid" => "49900.25",
      "ask" => "50100.75"
    }
    
    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: mock_response.to_json
    )

    result = @client.fetch_ticker("BTCAUD")
    
    assert_equal "50000.50", result["last"]
    assert_equal "49900.25", result["bid"]
    assert_equal "50100.75", result["ask"]
  end

  test "fetch_ticker should handle numeric values" do
    mock_response = {
      "last" => 50000.50,
      "bid" => 49900.25,
      "ask" => 50100.75
    }
    
    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: mock_response.to_json
    )

    result = @client.fetch_ticker("BTCAUD")
    
    assert_equal 50000.50, result["last"]
    assert_equal 49900.25, result["bid"]
    assert_equal 50100.75, result["ask"]
  end

  test "should raise ApiError for 404 response" do
    stub_request(:get, /coinjar/).to_return(status: 404)

    assert_raises(CoinjarApiClient::ApiError) do
      @client.fetch_ticker("INVALID")
    end
  end

  test "should raise ApiError for 429 response" do
    stub_request(:get, /coinjar/).to_return(status: 429)

    assert_raises(CoinjarApiClient::ApiError) do
      @client.fetch_ticker("BTCAUD")
    end
  end

  test "should raise ApiError for 500 response" do
    stub_request(:get, /coinjar/).to_return(status: 500)

    assert_raises(CoinjarApiClient::ApiError) do
      @client.fetch_ticker("BTCAUD")
    end
  end

  test "should raise InvalidResponseError for missing required fields" do
    mock_response = { "last" => "50000.00" } # Missing bid and ask
    
    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: mock_response.to_json
    )

    assert_raises(CoinjarApiClient::InvalidResponseError) do
      @client.fetch_ticker("BTCAUD")
    end
  end

  test "should raise InvalidResponseError for invalid numeric values" do
    mock_response = {
      "last" => "invalid",
      "bid" => "49900.00",
      "ask" => "50100.00"
    }
    
    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: mock_response.to_json
    )

    assert_raises(CoinjarApiClient::InvalidResponseError) do
      @client.fetch_ticker("BTCAUD")
    end
  end

  test "should raise InvalidResponseError for invalid JSON" do
    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: "invalid json"
    )

    assert_raises(CoinjarApiClient::InvalidResponseError) do
      @client.fetch_ticker("BTCAUD")
    end
  end

  test "should raise ApiError for timeout" do
    stub_request(:get, /coinjar/).to_timeout

    assert_raises(CoinjarApiClient::ApiError) do
      @client.fetch_ticker("BTCAUD")
    end
  end

  test "should raise ApiError for network error" do
    stub_request(:get, /coinjar/).to_raise(SocketError.new("Network error"))

    assert_raises(CoinjarApiClient::ApiError) do
      @client.fetch_ticker("BTCAUD")
    end
  end

  test "class method should delegate to instance" do
    mock_response = {
      "last" => "50000.00",
      "bid" => "49900.00",
      "ask" => "50100.00"
    }
    
    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: mock_response.to_json
    )

    result = CoinjarApiClient.fetch_ticker("BTCAUD")
    
    assert_equal "50000.00", result["last"]
    assert_equal "49900.00", result["bid"]
    assert_equal "50100.00", result["ask"]
  end

  test "should construct correct API URL" do
    expected_url = "https://data.exchange.coinjar.com/products/BTCAUD/ticker"
    
    stub_request(:get, expected_url).to_return(
      status: 200,
      body: { "last" => "50000.00", "bid" => "49900.00", "ask" => "50100.00" }.to_json
    )

    @client.fetch_ticker("BTCAUD")
    
    assert_requested :get, expected_url
  end
end 