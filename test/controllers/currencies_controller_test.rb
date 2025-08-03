require "test_helper"

class CurrenciesControllerTest < ActionDispatch::IntegrationTest
  def setup
    PriceSnapshot.destroy_all
    Currency.destroy_all

    @currency = Currency.create!(name: "Bitcoin", symbol: "BTCAUD")
    @eth_currency = Currency.create!(name: "Ethereum", symbol: "ETHAUD")
  end

  test "should get index" do
    get currencies_url

    assert_response :success
  end

  test "should get show" do
    get currency_url(@currency)

    assert_response :success
  end

  test "should redirect to index for invalid currency" do
    get currency_url(id: 99999)

    assert_redirected_to currencies_path
    assert_equal "Currency not found", flash[:error]
  end

  test "should capture prices successfully" do
    PriceSnapshot.destroy_all

    mock_response = {
      "last" => "50000.00",
      "bid" => "49900.00",
      "ask" => "50100.00"
    }

    stub_request(:get, /coinjar/).to_return(
      status: 200,
      body: mock_response.to_json
    )

    assert_difference "PriceSnapshot.count", 2 do
      post capture_prices_currencies_url
    end

    assert_redirected_to currencies_path
    assert_equal "Successfully captured prices for all currencies", flash[:notice]
  end

  test "should handle partial capture failures" do
    PriceSnapshot.destroy_all

    stub_request(:get, /BTCAUD/).to_return(
      status: 200,
      body: { "last" => "50000.00", "bid" => "49900.00", "ask" => "50100.00" }.to_json
    )

    # Mock failed ETH request
    stub_request(:get, /ETHAUD/).to_return(status: 404)

    assert_difference "PriceSnapshot.count", 1 do
      post capture_prices_currencies_url
    end

    assert_redirected_to currencies_path
    assert_match /Captured prices for BTCAUD/, flash[:warning]
    assert_match /ETHAUD/, flash[:warning]
  end

  test "should handle complete capture failure" do
    PriceSnapshot.destroy_all

    stub_request(:get, /coinjar/).to_return(status: 500)

    assert_no_difference "PriceSnapshot.count" do
      post capture_prices_currencies_url
    end

    assert_redirected_to currencies_path

    assert flash[:warning], "Expected warning flash message"
    assert_match /BTCAUD.*HTTP 500/, flash[:warning]
    assert_match /ETHAUD.*HTTP 500/, flash[:warning]
  end

  test "should show pagination in currency history" do
    25.times do |i|
      @currency.price_snapshots.create!(
        last: 50000 + i,
        bid: 49900 + i,
        ask: 50100 + i,
        captured_at: i.hours.ago
      )
    end

    get currency_url(@currency)
    assert_response :success
    assert_select ".pagination"
  end

  test "should cache currency index" do
    get currencies_url
    assert_response :success

    get currencies_url
    assert_response :success
  end

  test "should cache currency show with pagination" do
    @currency.price_snapshots.create!(
      last: 50000,
      bid: 49900,
      ask: 50100
    )

    get currency_url(@currency)
    assert_response :success

    get currency_url(@currency)
    assert_response :success
  end
end
