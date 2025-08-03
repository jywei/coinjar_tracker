require "test_helper"

class CurrencyTest < ActiveSupport::TestCase
  def setup
    @currency = Currency.new(name: "Bitcoin", symbol: "BTCAUD")
  end

  test "should be valid" do
    assert @currency.valid?
  end

  test "name should be present" do
    @currency.name = nil

    assert_not @currency.valid?
    assert_includes @currency.errors[:name], "can't be blank"
  end

  test "name should be unique" do
    @currency.save!

    duplicate_currency = Currency.new(name: "Bitcoin", symbol: "BTCAUD2")
    assert_not duplicate_currency.valid?
    assert_includes duplicate_currency.errors[:name], "has already been taken"
  end

  test "symbol should be present" do
    @currency.symbol = nil

    assert_not @currency.valid?
    assert_includes @currency.errors[:symbol], "can't be blank"
  end

  test "symbol should be unique" do
    @currency.save!

    duplicate_currency = Currency.new(name: "Bitcoin2", symbol: "BTCAUD")
    assert_not duplicate_currency.valid?
    assert_includes duplicate_currency.errors[:symbol], "has already been taken"
  end

  test "symbol should match format" do
    currency = Currency.new(name: "Test", symbol: "btc")
    assert_not currency.valid?

    currency.symbol = "BT"
    assert_not currency.valid?

    currency.symbol = "BTC"
    assert currency.valid?

    currency.symbol = "BTCAUD"
    assert currency.valid?

    currency.symbol = "BTCAUD12345"
    assert_not currency.valid?
  end

  test "should have many price snapshots" do
    @currency.save!

    assert_respond_to @currency, :price_snapshots
  end

  test "latest_price should return most recent snapshot" do
    @currency.save!

    old_snapshot = @currency.price_snapshots.create!(
      last: 50000, bid: 49900, ask: 50100, captured_at: 1.hour.ago
    )
    new_snapshot = @currency.price_snapshots.create!(
      last: 51000, bid: 50900, ask: 51100, captured_at: Time.current
    )

    assert_equal new_snapshot, @currency.latest_price
  end

  test "latest_price_value should return last price" do
    @currency.save!

    @currency.price_snapshots.create!(
      last: 50000, bid: 49900, ask: 50100, captured_at: Time.current
    )

    assert_equal 50000, @currency.latest_price_value
  end

  test "latest_price_value should return nil when no snapshots" do
    @currency.save!

    assert_nil @currency.latest_price_value
  end

  test "ordered scope should order by name" do
    Currency.destroy_all

    eth = Currency.create!(name: "Ethereum", symbol: "ETHAUD")
    btc = Currency.create!(name: "Bitcoin", symbol: "BTCAUD")

    ordered_currencies = Currency.ordered
    assert_equal btc, ordered_currencies.first
    assert_equal eth, ordered_currencies.last
  end
end
