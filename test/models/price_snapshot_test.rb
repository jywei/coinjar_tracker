require "test_helper"

class PriceSnapshotTest < ActiveSupport::TestCase
  def setup
    PriceSnapshot.destroy_all
    Currency.destroy_all

    @currency = Currency.create!(name: "Bitcoin", symbol: "BTCAUD")
    @snapshot = PriceSnapshot.new(
      currency: @currency,
      last: 50000,
      bid: 49900,
      ask: 50100
    )
  end

  test "should be valid" do
    assert @snapshot.valid?
  end

  test "currency should be present" do
    @snapshot.currency = nil

    assert_not @snapshot.valid?
    assert_includes @snapshot.errors[:currency], "must exist"
  end

  test "last should be present" do
    @snapshot.last = nil

    assert_not @snapshot.valid?
    assert_includes @snapshot.errors[:last], "can't be blank"
  end

  test "last should be positive" do
    @snapshot.last = 0
    assert_not @snapshot.valid?

    @snapshot.last = -100
    assert_not @snapshot.valid?

    @snapshot.last = 50000
    assert @snapshot.valid?
  end

  test "bid should be present" do
    @snapshot.bid = nil

    assert_not @snapshot.valid?
    assert_includes @snapshot.errors[:bid], "can't be blank"
  end

  test "bid should be positive" do
    @snapshot.bid = 0
    assert_not @snapshot.valid?

    @snapshot.bid = -100
    assert_not @snapshot.valid?

    @snapshot.bid = 49900
    assert @snapshot.valid?
  end

  test "ask should be present" do
    @snapshot.ask = nil

    assert_not @snapshot.valid?
    assert_includes @snapshot.errors[:ask], "can't be blank"
  end

  test "ask should be positive" do
    @snapshot.ask = 0
    assert_not @snapshot.valid?

    @snapshot.ask = -100
    assert_not @snapshot.valid?

    @snapshot.ask = 50100
    assert @snapshot.valid?
  end

  test "should set captured_at automatically" do
    @snapshot.save!

    assert_not_nil @snapshot.captured_at
    # New syntax that I learned from the exercise
    assert_in_delta Time.current, @snapshot.captured_at, 1.second
  end

  test "spread should calculate correctly" do
    @snapshot.save!

    expected_spread = @snapshot.ask - @snapshot.bid
    assert_equal expected_spread, @snapshot.spread
  end

  test "spread_percentage should calculate correctly" do
    @snapshot.save!

    expected_percentage = ((@snapshot.ask - @snapshot.bid) / @snapshot.bid * 100).round(2)
    assert_equal expected_percentage, @snapshot.spread_percentage
  end

  test "spread_percentage should handle zero bid" do
    @snapshot.bid = 0.01
    @snapshot.save!

    assert @snapshot.spread_percentage >= 0
  end

  test "formatted_captured_at should format correctly" do
    @snapshot.captured_at = Time.new(2023, 12, 25, 14, 30, 45)
    @snapshot.save!

    expected_time = @snapshot.captured_at.strftime("%Y-%m-%d %H:%M:%S")
    assert_equal expected_time, @snapshot.formatted_captured_at
  end

  test "recent scope should order by captured_at desc" do
    @currency.price_snapshots.destroy_all

    old_snapshot = @currency.price_snapshots.create!(
      last: 50000, bid: 49900, ask: 50100, captured_at: 1.hour.ago
    )
    new_snapshot = @currency.price_snapshots.create!(
      last: 51000, bid: 50900, ask: 51100, captured_at: Time.current
    )

    recent_snapshots = PriceSnapshot.recent
    assert_equal new_snapshot, recent_snapshots.first
    assert_equal old_snapshot, recent_snapshots.last
  end

  test "for_currency scope should filter by currency" do
    eth_currency = Currency.create!(name: "Ethereum", symbol: "ETHAUD")

    btc_snapshot = @currency.price_snapshots.create!(
      last: 50000, bid: 49900, ask: 50100
    )
    eth_snapshot = eth_currency.price_snapshots.create!(
      last: 3000, bid: 2990, ask: 3010
    )

    btc_snapshots = PriceSnapshot.for_currency(@currency)
    assert_includes btc_snapshots, btc_snapshot
    assert_not_includes btc_snapshots, eth_snapshot
  end

  test "within_hours scope should filter by time" do
    old_snapshot = @currency.price_snapshots.create!(
      last: 50000, bid: 49900, ask: 50100, captured_at: 3.hours.ago
    )
    recent_snapshot = @currency.price_snapshots.create!(
      last: 51000, bid: 50900, ask: 51100, captured_at: 1.hour.ago
    )

    recent_snapshots = PriceSnapshot.within_hours(2)
    assert_includes recent_snapshots, recent_snapshot
    assert_not_includes recent_snapshots, old_snapshot
  end
end
