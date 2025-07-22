require "test_helper"

class AdrsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get adrs_create_url
    assert_response :success
  end

  test "should get accept" do
    get adrs_accept_url
    assert_response :success
  end

  test "should get supersede" do
    get adrs_supersede_url
    assert_response :success
  end
end
