require "test_helper"

class ChoresControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get chores_new_url
    assert_response :success
  end

  test "should get create" do
    get chores_create_url
    assert_response :success
  end
end
