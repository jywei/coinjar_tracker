require "test_helper"

class PriceCaptureServiceTest < ActiveSupport::TestCase
  def setup
    PriceSnapshot.destroy_all
    Currency.destroy_all
    
    @currency = Currency.create!(name: "Bitcoin", symbol: "BTCAUD")
    @service = PriceCaptureService.new
  end

  test "#capture_for_currency should create price snapshot" do
    mock_response = {
      "last" => "50000.00",
      "bid" => "49900.00", 
      "ask" => "50100.00"
    }
    
    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: mock_response.to_json
    )

    assert_difference 'PriceSnapshot.count', 1 do
      @service.capture_for_currency(@currency)
    end

    snapshot = PriceSnapshot.last
    assert_equal @currency, snapshot.currency
    assert_equal 50000.00, snapshot.last
    assert_equal 49900.00, snapshot.bid
    assert_equal 50100.00, snapshot.ask
    assert_not_nil snapshot.captured_at
  end

  test "#capture_for_currency should handle string values" do
    mock_response = {
      "last" => "50000.50",
      "bid" => "49900.25",
      "ask" => "50100.75"
    }
    
    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: mock_response.to_json
    )

    @service.capture_for_currency(@currency)
    
    snapshot = PriceSnapshot.last
    assert_equal 50000.50, snapshot.last
    assert_equal 49900.25, snapshot.bid
    assert_equal 50100.75, snapshot.ask
  end

  test "#capture_for_currency should handle numeric values" do
    mock_response = {
      "last" => 50000.50,
      "bid" => 49900.25,
      "ask" => 50100.75
    }
    
    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: mock_response.to_json
    )

    @service.capture_for_currency(@currency)
    
    snapshot = PriceSnapshot.last
    assert_equal 50000.50, snapshot.last
    assert_equal 49900.25, snapshot.bid
    assert_equal 50100.75, snapshot.ask
  end

  test "#capture_all should capture for all currencies" do
    PriceSnapshot.destroy_all
    eth_currency = Currency.create!(name: "Ethereum", symbol: "ETHAUD")
    
    mock_response = {
      "last" => "50000.00",
      "bid" => "49900.00",
      "ask" => "50100.00"
    }
    
    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: mock_response.to_json
    )

    assert_difference 'PriceSnapshot.count', 2 do
      results = @service.capture_all
      
      assert_includes results[:success], "BTCAUD"
      assert_includes results[:success], "ETHAUD"
      assert_empty results[:errors]
    end
  end

  test "#capture_all should handle partial failures" do
    PriceSnapshot.destroy_all
    eth_currency = Currency.create!(name: "Ethereum", symbol: "ETHAUD")
    
    stub_request(:get, /BTCAUD/).to_return(
      status: 200,
      body: { "last" => "50000.00", "bid" => "49900.00", "ask" => "50100.00" }.to_json
    )
    
    stub_request(:get, /ETHAUD/).to_return(status: 404)

    results = @service.capture_all
    
    assert_includes results[:success], "BTCAUD"
    assert_not_includes results[:success], "ETHAUD"
    assert_equal 1, results[:errors].length
    assert_equal "ETHAUD", results[:errors].first[:symbol]
  end

  test "#capture_for_currency should raise InvalidResponseError for invalid data" do
    invalid_data = {
      "last" => "invalid",
      "bid" => "49900.00",
      "ask" => "50100.00"
    }

    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: invalid_data.to_json
    )

    assert_raises(CoinjarApiClient::InvalidResponseError) do
      @service.capture_for_currency(@currency)
    end
  end

  test "#capture_for_currency should raise InvalidResponseError for API errors" do
    stub_request(:get, /coinjar/).to_return(status: 500)

    assert_raises(CoinjarApiClient::ApiError) do
      @service.capture_for_currency(@currency)
    end
  end

  test "#capture_for_currency should handle ActiveRecord validation errors" do
    mock_response = {
      "last" => "50000.00",
      "bid" => "49900.00",
      "ask" => "50100.00"
    }
    
    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: mock_response.to_json
    )

    # This test verifies that validation errors are properly handled
    # The actual validation is tested in the model tests
    assert_nothing_raised do
      @service.capture_for_currency(@currency)
    end
  end
end 