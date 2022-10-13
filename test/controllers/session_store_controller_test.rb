require "test_helper"

class SessionStoreControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get session_store_new_url
    assert_response :success
  end

  test "should get create" do
    get session_store_create_url
    assert_response :success
  end

  test "should get destroy" do
    get session_store_destroy_url
    assert_response :success
  end
end
