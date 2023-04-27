require "test_helper"

class VehiclesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get vehicles_index_url
    assert_response :success
  end

  test "should get show" do
    get vehicles_show_url
    assert_response :success
  end
end
