require "test_helper"

class PriceSnapshotsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get price_snapshots_url
    
    assert_response :success
  end
end
