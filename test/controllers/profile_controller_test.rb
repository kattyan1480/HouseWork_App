require "test_helper"

class ProfileControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get profile_index_url
    assert_response :success
  end

  test "should get edit" do
    get profile_edit_url
    assert_response :success
  end

  test "should get updata" do
    get profile_updata_url
    assert_response :success
  end
end
